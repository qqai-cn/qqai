import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:web/web.dart';

/// Trigger a file download in the browser (dart2js / dart2wasm).
void downloadUint8ListAsFile(
  Uint8List bytes,
  String filename, {
  String? mimeType,
}) {
  final type = mimeType ?? 'application/octet-stream';
  final blob = Blob(
    [bytes.toJS].toJS,
    BlobPropertyBag(type: type),
  );
  final url = URL.createObjectURL(blob);
  final anchor = HTMLAnchorElement()
    ..href = url
    ..download = filename;
  anchor.click();
  URL.revokeObjectURL(url);
}

void revokeBlobUrlIfNeeded(String url) {
  if (url.startsWith('blob:')) {
    URL.revokeObjectURL(url);
  }
}

String createBlobUrlFromBytes(
  Uint8List bytes, {
  String mimeType = 'application/octet-stream',
}) {
  final blob = Blob(
    [bytes.toJS].toJS,
    BlobPropertyBag(type: mimeType),
  );
  return URL.createObjectURL(blob);
}

/// Encode to WebP using browser canvas (`toDataURL`), for targets without `dart:html`.
Future<Uint8List?> encodeWebpViaBrowserCanvas(img.Image image) async {
  final pngBytes = img.encodePng(image);
  final blob = Blob(
    [pngBytes.toJS].toJS,
    BlobPropertyBag(type: 'image/png'),
  );
  final url = URL.createObjectURL(blob);
  final imgEl = HTMLImageElement()..src = url;
  try {
    await imgEl.decode().toDart;
    final w = image.width;
    final h = image.height;
    final canvas = HTMLCanvasElement()
      ..width = w
      ..height = h;
    final ctx = canvas.getContext('2d');
    if (ctx == null) return null;
    final c2d = ctx as CanvasRenderingContext2D;
    c2d.drawImage(imgEl, 0, 0);
    final webpDataUrl = canvas.toDataURL('image/webp', (0.92).toJS);
    final parts = webpDataUrl.split(',');
    if (parts.length < 2) return null;
    return Uint8List.fromList(base64Decode(parts[1]));
  } finally {
    URL.revokeObjectURL(url);
  }
}
