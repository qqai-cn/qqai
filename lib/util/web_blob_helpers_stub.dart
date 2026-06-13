import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Stub when not compiling with `dart:js_interop` (VM / mobile).
void downloadUint8ListAsFile(
  Uint8List bytes,
  String filename, {
  String? mimeType,
}) {}

void revokeBlobUrlIfNeeded(String url) {}

/// 为 [Uint8List] 创建可播放/下载的 blob: URL（仅 Web）。
String createBlobUrlFromBytes(
  Uint8List bytes, {
  String mimeType = 'application/octet-stream',
}) =>
    '';

Future<Uint8List?> encodeWebpViaBrowserCanvas(img.Image image) async => null;
