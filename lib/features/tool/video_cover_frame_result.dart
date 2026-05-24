import 'dart:typed_data';

import 'package:image/image.dart' as img;

class CoverStyleFramesResult {
  const CoverStyleFramesResult({
    required this.frames,
    this.durationMs,
  });

  final List<img.Image?> frames;

  /// Web 端从 `<video>` 元数据读取；原生端由调用方提供时长。
  final int? durationMs;
}

class StyledCoverGenerateResult {
  const StyledCoverGenerateResult({
    required this.bytes,
    this.durationMs,
  });

  final Uint8List bytes;
  final int? durationMs;
}

typedef CoverPreviewProgressCallback = void Function(
  Uint8List partialBytes,
  int framesReady,
  int totalFrames,
);
