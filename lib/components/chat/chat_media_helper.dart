import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qqai/features/tool/video_cover_tool.dart';
import 'package:qqai/util/api_base_client.dart';
import 'package:qqai/util/image_bytes_xfile.dart';
import 'package:video_player/video_player.dart';

const chatUploadDirectory = 'qqai/chat';

Future<int> readVideoDurationMs(XFile video) async {
  VideoPlayerController? controller;
  try {
    controller = _videoControllerForPath(video.path);
    await controller.initialize();
    return controller.value.duration.inMilliseconds;
  } catch (e) {
    debugPrint('Read video duration error: $e');
    return 0;
  } finally {
    await controller?.dispose();
  }
}

Future<(double?, double?)> readVideoSize(XFile video) async {
  VideoPlayerController? controller;
  try {
    controller = _videoControllerForPath(video.path);
    await controller.initialize();
    final size = controller.value.size;
    return (size.width, size.height);
  } catch (e) {
    debugPrint('Read video size error: $e');
    return (null, null);
  } finally {
    await controller?.dispose();
  }
}

VideoPlayerController _videoControllerForPath(String path) {
  final uri = Uri.tryParse(path);
  if (uri != null && uri.hasScheme && uri.scheme != 'file') {
    return VideoPlayerController.networkUrl(uri);
  }
  if (kIsWeb) {
    return VideoPlayerController.networkUrl(uri ?? Uri.parse(path));
  }
  return VideoPlayerController.file(File(uri?.toFilePath() ?? path));
}

Future<String?> generateAndUploadVideoCover(XFile video) async {
  try {
    final bytes = await generateVideoCoverBytes(
      videoPath: video.path,
      imageFormat: ImageFormat.JPEG,
    );
    final coverFile = xFileFromImageBytes(bytes, baseName: 'chat-video-cover');
    return ApiBaseClient.uploadFile(
      file: coverFile,
      directory: chatUploadDirectory,
    );
  } catch (e) {
    debugPrint('chat video cover: $e');
    return null;
  }
}

Future<String> uploadChatFile(XFile file) {
  return ApiBaseClient.uploadFile(
    file: file,
    directory: chatUploadDirectory,
  );
}
