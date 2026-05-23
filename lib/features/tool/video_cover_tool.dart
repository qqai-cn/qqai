import 'package:flutter/foundation.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image/image.dart' as img;

import 'video_cover_frames.dart';

const List<String> qqaiVideoCoverImageExtensions = [
  'jpg',
  'jpeg',
  'png',
  'webp',
];

const int qqaiVideoCoverTimeMs = 1000;

/// 封面画布宽 400px，缩略图略大于 2x 即可，避免按原视频分辨率抽帧。
const int qqaiCoverThumbMaxWidth = 800;

/// 并行抽帧批次大小，避免同时打开过多原生解码器。
const int qqaiCoverThumbBatchSize = 4;

class QqaiVideoCoverStyle {
  const QqaiVideoCoverStyle({required this.id, required this.label});

  final int id;
  final String label;
}

const List<QqaiVideoCoverStyle> qqaiVideoCoverStyles = [
  QqaiVideoCoverStyle(id: 1, label: '横版封面1'),
  QqaiVideoCoverStyle(id: 2, label: '横版封面2'),
  QqaiVideoCoverStyle(id: 3, label: '竖版封面1'),
  QqaiVideoCoverStyle(id: 4, label: '竖版封面2'),
];

const double qqaiVideoCoverAspectRatio = 400 / 500;

Future<Uint8List> generateVideoCoverBytes({
  required String videoPath,
  int timeMs = qqaiVideoCoverTimeMs,
  ImageFormat imageFormat = ImageFormat.WEBP,
  int quality = 90,
}) {
  return VideoThumbnail.thumbnailData(
    video: videoPath,
    imageFormat: imageFormat,
    maxHeight: 0,
    maxWidth: 0,
    timeMs: timeMs,
    quality: quality,
  );
}

Future<Uint8List> generateStyledVideoCoverBytes({
  required String videoPath,
  required int durationMs,
  int styleId = 1,
  int quality = 90,
}) async {
  final frames = await _generateStyleFrames(
    videoPath: videoPath,
    durationMs: durationMs,
    styleId: styleId,
  );
  return compute(
    _composeStyledCover,
    _StyledCoverComposeArgs(frames: frames, styleId: styleId, quality: quality),
  );
}

class _StyledCoverComposeArgs {
  const _StyledCoverComposeArgs({
    required this.frames,
    required this.styleId,
    required this.quality,
  });

  final List<img.Image> frames;
  final int styleId;
  final int quality;
}

Uint8List _composeStyledCover(_StyledCoverComposeArgs args) {
  final frames = args.frames;
  final styleId = args.styleId;
  final canvas = _createCoverCanvas();
  switch (styleId) {
    case 1:
      _drawImageSlot(canvas, frames[0], 17, 16, 367, 205);
      _drawSeparator(canvas, 17, 221, 367, 4);
      _drawReflection(canvas, frames[0], 17, 225, 367, 40);
      _drawImageSlot(canvas, frames[1], 17, 265, 179, 99);
      _drawImageSlot(canvas, frames[2], 204, 265, 179, 99);
      _drawImageSlot(canvas, frames[3], 17, 372, 179, 99);
      _drawImageSlot(canvas, frames[4], 204, 372, 179, 99);
    case 2:
      _drawImageSlot(canvas, frames[0], 17, 16, 367, 205);
      _drawSeparator(canvas, 17, 221, 367, 4);
      _drawReflection(canvas, frames[0], 17, 225, 367, 40);
      for (var i = 0; i < 9; i++) {
        final x = 17 + (i % 3) * 124;
        final y = 265 + (i ~/ 3) * 72;
        _drawImageSlot(canvas, frames[i + 1], x, y, 119, 67);
      }
    case 3:
      _drawImageSlot(canvas, frames[0], 94, 30, 211, 441);
    default:
      for (var i = 0; i < 6; i++) {
        final x = 17 + (i % 3) * 124;
        final y = i < 3 ? 40 : 255;
        _drawImageSlot(canvas, frames[i], x, y, 119, 210);
      }
  }
  return Uint8List.fromList(img.encodePng(canvas));
}

Future<List<img.Image>> _generateStyleFrames({
  required String videoPath,
  required int durationMs,
  required int styleId,
}) async {
  final count = _frameCountForStyle(styleId);
  final step = durationMs > 0
      ? durationMs ~/ (count + 1)
      : qqaiVideoCoverTimeMs;
  final timePoints = List<int>.generate(count, (i) {
    if (durationMs <= 0) return qqaiVideoCoverTimeMs;
    return (step * (i + 1)).clamp(0, durationMs);
  });

  final frames = <img.Image>[];
  final extracted = await extractCoverStyleFrames(
    videoPath: videoPath,
    timePointsMs: timePoints,
    maxWidth: qqaiCoverThumbMaxWidth,
    batchSize: qqaiCoverThumbBatchSize,
  );
  frames.addAll(extracted.whereType<img.Image>());

  if (frames.isEmpty) {
    throw StateError('视频封面生成失败');
  }
  while (frames.length < count) {
    frames.add(img.Image.from(frames.last));
  }
  return frames;
}

int _frameCountForStyle(int styleId) {
  return switch (styleId) {
    1 => 5,
    2 => 10,
    3 => 1,
    _ => 6,
  };
}

img.Image _createCoverCanvas() {
  final canvas = img.Image(width: 400, height: 500);
  for (var y = 0; y < canvas.height; y++) {
    final t = y / (canvas.height - 1);
    final v = (255 - (85 * t)).round();
    img.fillRect(
      canvas,
      x1: 0,
      y1: y,
      x2: canvas.width,
      y2: y,
      color: img.ColorRgb8(v, v, v),
    );
  }
  return canvas;
}

void _drawImageSlot(
  img.Image canvas,
  img.Image source,
  int x,
  int y,
  int width,
  int height,
) {
  final cropped = _resizeCrop(source, width, height);
  img.compositeImage(canvas, cropped, dstX: x, dstY: y);
}

void _drawSeparator(img.Image canvas, int x, int y, int width, int height) {
  for (var dx = 0; dx < width; dx++) {
    final centerDistance = ((dx / (width - 1)) - 0.5).abs() * 2;
    final v = (54 + (201 * centerDistance)).round();
    img.fillRect(
      canvas,
      x1: x + dx,
      y1: y,
      x2: x + dx,
      y2: y + height - 1,
      color: img.ColorRgb8(v, v, v),
    );
  }
}

void _drawReflection(
  img.Image canvas,
  img.Image source,
  int x,
  int y,
  int width,
  int height,
) {
  final reflection = img.flipVertical(_resizeCrop(source, width, 205));
  final cropped = img.copyCrop(
    reflection,
    x: 0,
    y: 0,
    width: width,
    height: height,
  );
  for (var py = 0; py < cropped.height; py++) {
    final opacity = ((1 - py / cropped.height) * 0.45).clamp(0, 1);
    for (var px = 0; px < cropped.width; px++) {
      final pixel = cropped.getPixel(px, py);
      cropped.setPixelRgba(
        px,
        py,
        pixel.r,
        pixel.g,
        pixel.b,
        (255 * opacity).round(),
      );
    }
  }
  img.compositeImage(canvas, cropped, dstX: x, dstY: y);
}

img.Image _resizeCrop(img.Image source, int width, int height) {
  final sourceAspect = source.width / source.height;
  final targetAspect = width / height;
  late img.Image cropped;
  if (sourceAspect > targetAspect) {
    final cropWidth = (source.height * targetAspect).round();
    cropped = img.copyCrop(
      source,
      x: ((source.width - cropWidth) / 2).round(),
      y: 0,
      width: cropWidth,
      height: source.height,
    );
  } else {
    final cropHeight = (source.width / targetAspect).round();
    cropped = img.copyCrop(
      source,
      x: 0,
      y: ((source.height - cropHeight) / 2).round(),
      width: source.width,
      height: cropHeight,
    );
  }
  return img.copyResize(cropped, width: width, height: height);
}
