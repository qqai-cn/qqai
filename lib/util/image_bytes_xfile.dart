import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';

/// 根据文件头识别图片 MIME，避免扩展名与真实格式不一致导致解码失败。
String imageMimeTypeFromBytes(Uint8List bytes) {
  if (bytes.length >= 3 &&
      bytes[0] == 0xFF &&
      bytes[1] == 0xD8 &&
      bytes[2] == 0xFF) {
    return 'image/jpeg';
  }
  if (bytes.length >= 8 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47) {
    return 'image/png';
  }
  if (bytes.length >= 12 &&
      bytes[0] == 0x52 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x46 &&
      bytes[3] == 0x46 &&
      bytes[8] == 0x57 &&
      bytes[9] == 0x45 &&
      bytes[10] == 0x42 &&
      bytes[11] == 0x50) {
    return 'image/webp';
  }
  if (bytes.length >= 6 &&
      bytes[0] == 0x47 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x46) {
    return 'image/gif';
  }
  return 'image/png';
}

String imageExtensionForMime(String mime) {
  return switch (mime) {
    'image/jpeg' => 'jpg',
    'image/webp' => 'webp',
    'image/gif' => 'gif',
    _ => 'png',
  };
}

XFile xFileFromImageBytes(
  Uint8List bytes, {
  String baseName = 'image',
}) {
  final mime = imageMimeTypeFromBytes(bytes);
  final ext = imageExtensionForMime(mime);
  return XFile.fromData(
    bytes,
    name: '$baseName.$ext',
    mimeType: mime,
  );
}
