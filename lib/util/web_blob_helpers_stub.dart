import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Stub when not compiling with `dart:js_interop` (VM / mobile).
void downloadUint8ListAsFile(
  Uint8List bytes,
  String filename, {
  String? mimeType,
}) {}

void revokeBlobUrlIfNeeded(String url) {}

Future<Uint8List?> encodeWebpViaBrowserCanvas(img.Image image) async => null;
