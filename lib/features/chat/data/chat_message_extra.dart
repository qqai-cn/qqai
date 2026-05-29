import 'dart:convert';

import 'package:flutter_chat_core/flutter_chat_core.dart';

Map<String, dynamic>? parseChatMessageExtra(String? extra) {
  if (extra == null || extra.isEmpty) return null;
  try {
    final decoded = jsonDecode(extra);
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }
  } catch (_) {}
  return null;
}

String? encodeMessageExtra(Message message) {
  if (message is VideoMessage) {
    final meta = message.metadata ?? {};
    final payload = <String, dynamic>{
      if (meta['duration'] != null) 'duration': meta['duration'],
      if (meta['coverUrl'] != null) 'coverUrl': meta['coverUrl'],
      if (message.width != null) 'width': message.width,
      if (message.height != null) 'height': message.height,
      if (message.size != null) 'size': message.size,
      if (message.name != null && message.name!.isNotEmpty) 'name': message.name,
    };
    return payload.isEmpty ? null : jsonEncode(payload);
  }
  if (message is FileMessage) {
    return jsonEncode({
      'name': message.name,
      'size': message.size,
      if (message.mimeType != null) 'mimeType': message.mimeType,
    });
  }
  return null;
}
