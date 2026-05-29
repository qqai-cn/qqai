import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/api_base_client.dart';

bool isRemoteChatFileUrl(String source) {
  final uri = Uri.tryParse(source);
  return uri != null &&
      uri.hasScheme &&
      (uri.scheme == 'http' || uri.scheme == 'https');
}

String chatFileDisplayName(FileMessage message) {
  final name = message.name.trim();
  if (name.isNotEmpty && name != '附件' && name != '语音') {
    return _sanitizeFileName(name);
  }
  final fromUrl = _fileNameFromUrl(message.source);
  if (fromUrl.isNotEmpty) return fromUrl;
  return 'file';
}

String _fileNameFromUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return '';
  final segment = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
  return _sanitizeFileName(segment);
}

String _sanitizeFileName(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '';
  return trimmed.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
}

Future<void> downloadChatFile(FileMessage message) async {
  final source = message.source.trim();
  if (source.isEmpty) {
    throw Exception('文件地址为空');
  }

  if (kIsWeb) {
    if (!isRemoteChatFileUrl(source)) {
      throw Exception('当前环境无法下载本地文件');
    }
    final uri = Uri.parse(source);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      throw Exception('无法打开下载链接');
    }
    return;
  }

  if (isRemoteChatFileUrl(source)) {
    final savePath = await _resolveSavePath(chatFileDisplayName(message));
    final completer = Completer<void>();
    await ApiBaseClient.download(
      url: source,
      savePath: savePath,
      onSuccess: () {
        if (!completer.isCompleted) completer.complete();
      },
      onError: (error) {
        if (!completer.isCompleted) completer.completeError(error);
      },
    );
    await completer.future;
    await OpenFilex.open(savePath);
    return;
  }

  final localFile = File(source);
  if (!await localFile.exists()) {
    throw Exception('本地文件不存在');
  }
  await OpenFilex.open(source);
}

Future<String> _resolveSavePath(String fileName) async {
  final dir = await getApplicationDocumentsDirectory();
  final folder = Directory('${dir.path}/chat_downloads');
  if (!await folder.exists()) {
    await folder.create(recursive: true);
  }

  var candidate = '${folder.path}/$fileName';
  if (!await File(candidate).exists()) {
    return candidate;
  }

  final dot = fileName.lastIndexOf('.');
  final stem = dot > 0 ? fileName.substring(0, dot) : fileName;
  final ext = dot > 0 ? fileName.substring(dot) : '';
  final stamp = DateTime.now().millisecondsSinceEpoch;
  return '${folder.path}/${stem}_$stamp$ext';
}
