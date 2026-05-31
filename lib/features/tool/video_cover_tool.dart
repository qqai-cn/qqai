import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image/image.dart' as img;

import 'video_cover_frame_result.dart';
import 'video_cover_frames.dart';
import 'video_cover_sampling.dart';

const List<String> qqaiVideoCoverImageExtensions = [
  'jpg',
  'jpeg',
  'png',
  'webp',
];

const int qqaiVideoCoverTimeMs = qqaiCoverFallbackTimeMs;

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

const double qqaiVideoCoverCanvasWidth = 400;
const double qqaiVideoCoverCanvasHeight = 800;

const double qqaiVideoCoverAspectRatio = qqaiVideoCoverCanvasWidth / 500;

const int qqaiStyledCoverW = 400;
const int qqaiStyledCoverH = 500;
const int qqaiCoverGap = 4;

const int qqaiCoverMainH = 205;
const int qqaiCoverSepH = 4;
const int qqaiCoverReflH = 40;
const int qqaiCoverGridTop = qqaiCoverMainH + qqaiCoverSepH + qqaiCoverReflH;

const int qqaiCoverStyle1Row1H =
    (qqaiStyledCoverH - qqaiCoverGridTop - qqaiCoverGap) ~/ 2;
const int qqaiCoverStyle1ColW = (qqaiStyledCoverW - qqaiCoverGap) ~/ 2;

const int qqaiCoverStyle2RowH =
    (qqaiStyledCoverH - qqaiCoverGridTop - 2 * qqaiCoverGap) ~/ 3;

const int qqaiCoverStyle4RowH = (qqaiStyledCoverH - qqaiCoverGap) ~/ 2;

const List<int> qqaiCoverThreeColWidths = [131, 131, 130];

int qqaiCoverStyle1Row2H() =>
    qqaiStyledCoverH - qqaiCoverGridTop - qqaiCoverGap - qqaiCoverStyle1Row1H;

int qqaiCoverThreeColX(int col) {
  var x = 0;
  for (var i = 0; i < col; i++) {
    x += qqaiCoverThreeColWidths[i] + qqaiCoverGap;
  }
  return x;
}

bool qqaiVideoIsPortrait(double aspectRatio) => aspectRatio < 1.0;

bool qqaiVideoCoverStyleIsLandscape(int styleId) => styleId == 1 || styleId == 2;

bool qqaiVideoCoverStyleIsPortrait(int styleId) => styleId == 3 || styleId == 4;

bool qqaiVideoCoverStyleMatchesAspectRatio(int styleId, double aspectRatio) {
  return qqaiVideoIsPortrait(aspectRatio)
      ? qqaiVideoCoverStyleIsPortrait(styleId)
      : qqaiVideoCoverStyleIsLandscape(styleId);
}

List<QqaiVideoCoverStyle> qqaiVideoCoverStylesForAspectRatio(double aspectRatio) {
  return qqaiVideoCoverStyles
      .where((style) => qqaiVideoCoverStyleMatchesAspectRatio(style.id, aspectRatio))
      .toList();
}

int qqaiDefaultVideoCoverStyleForAspectRatio(double aspectRatio) {
  return qqaiVideoIsPortrait(aspectRatio) ? 3 : 1;
}

int normalizeVideoCoverStyleForAspectRatio(int styleId, double aspectRatio) {
  if (qqaiVideoCoverStyleMatchesAspectRatio(styleId, aspectRatio)) {
    return styleId;
  }
  return qqaiDefaultVideoCoverStyleForAspectRatio(aspectRatio);
}

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
    maxWidth: qqaiCoverThumbMaxWidth,
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
  final result = await generateStyledVideoCoverBytesProgressive(
    videoPath: videoPath,
    durationMs: durationMs,
    styleId: styleId,
    quality: quality,
  );
  return result.bytes;
}

Future<StyledCoverGenerateResult> generateStyledVideoCoverBytesProgressive({
  required String videoPath,
  int? durationMs,
  int styleId = 1,
  int quality = 90,
  CoverPreviewProgressCallback? onProgress,
}) async {
  final count = frameCountForCoverStyle(styleId);
  final resolvedDurationMs = durationMs ?? 0;
  final timePoints = resolvedDurationMs > 0
      ? computeCoverStyleTimePoints(resolvedDurationMs, styleId)
      : null;
  final frameSlots = List<img.Image?>.filled(count, null);

  void handleFrame(int index, img.Image frame) {
    if (index < 0 || index >= count) return;
    frameSlots[index] = frame;

    var ready = 0;
    for (final slot in frameSlots) {
      if (slot == null) break;
      ready++;
    }
    if (ready != 1) return;

    // 首帧快速 JPEG 预览，避免主线程反复拼完整封面。
    onProgress?.call(
      Uint8List.fromList(img.encodeJpg(frame, quality: 85)),
      1,
      count,
    );
  }

  final extraction = await extractCoverStyleFrames(
    videoPath: videoPath,
    timePointsMs: timePoints,
    styleId: styleId,
    durationHintMs: resolvedDurationMs,
    maxWidth: qqaiCoverThumbMaxWidth,
    batchSize: qqaiCoverThumbBatchSize,
    onFrameExtracted: handleFrame,
  );

  final detectedDurationMs = extraction.durationMs;
  final effectiveDurationMs = detectedDurationMs ?? resolvedDurationMs;
  final extractedFrames = extraction.frames.whereType<img.Image>().toList();
  if (extractedFrames.isEmpty) {
    throw StateError('视频封面生成失败');
  }

  final paddedFrames = _padFrames(extractedFrames, count);
  final bytes = await compute(
    _composeStyledCover,
    _StyledCoverComposeArgs(
      frames: paddedFrames,
      styleId: styleId,
      quality: quality,
    ),
  );

  return StyledCoverGenerateResult(
    bytes: bytes,
    durationMs: effectiveDurationMs > 0
        ? effectiveDurationMs
        : detectedDurationMs,
  );
}

List<int> computeStyleTimePoints(int durationMs, int styleId) {
  return computeCoverStyleTimePoints(durationMs, styleId);
}

List<img.Image> _padFrames(List<img.Image> frames, int count) {
  final padded = List<img.Image>.from(frames);
  while (padded.length < count) {
    padded.add(img.Image.from(padded.last));
  }
  return padded;
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
  if (styleId == 1) {
    _drawImageSlot(canvas, frames[0], 0, 0, qqaiStyledCoverW, qqaiCoverMainH);
    _drawSeparator(canvas, 0, qqaiCoverMainH, qqaiStyledCoverW, qqaiCoverSepH);
    _drawReflection(
      canvas,
      frames[0],
      0,
      qqaiCoverMainH + qqaiCoverSepH,
      qqaiStyledCoverW,
      qqaiCoverReflH,
    );
    final row2Y = qqaiCoverGridTop + qqaiCoverStyle1Row1H + qqaiCoverGap;
    _drawImageSlot(
      canvas,
      frames[1],
      0,
      qqaiCoverGridTop,
      qqaiCoverStyle1ColW,
      qqaiCoverStyle1Row1H,
    );
    _drawImageSlot(
      canvas,
      frames[2],
      qqaiCoverStyle1ColW + qqaiCoverGap,
      qqaiCoverGridTop,
      qqaiCoverStyle1ColW,
      qqaiCoverStyle1Row1H,
    );
    _drawImageSlot(
      canvas,
      frames[3],
      0,
      row2Y,
      qqaiCoverStyle1ColW,
      qqaiCoverStyle1Row2H(),
    );
    _drawImageSlot(
      canvas,
      frames[4],
      qqaiCoverStyle1ColW + qqaiCoverGap,
      row2Y,
      qqaiCoverStyle1ColW,
      qqaiCoverStyle1Row2H(),
    );
  } else if (styleId == 2) {
    _drawImageSlot(canvas, frames[0], 0, 0, qqaiStyledCoverW, qqaiCoverMainH);
    _drawSeparator(canvas, 0, qqaiCoverMainH, qqaiStyledCoverW, qqaiCoverSepH);
    _drawReflection(
      canvas,
      frames[0],
      0,
      qqaiCoverMainH + qqaiCoverSepH,
      qqaiStyledCoverW,
      qqaiCoverReflH,
    );
    for (var i = 0; i < 9; i++) {
      final col = i % 3;
      final row = i ~/ 3;
      _drawImageSlot(
        canvas,
        frames[i + 1],
        qqaiCoverThreeColX(col),
        qqaiCoverGridTop + row * (qqaiCoverStyle2RowH + qqaiCoverGap),
        qqaiCoverThreeColWidths[col],
        qqaiCoverStyle2RowH,
      );
    }
  } else if (styleId == 3) {
    _drawImageSlot(canvas, frames[0], 0, 0, qqaiStyledCoverW, qqaiStyledCoverH);
  } else {
    for (var i = 0; i < 6; i++) {
      final col = i % 3;
      final row = i ~/ 3;
      _drawImageSlot(
        canvas,
        frames[i],
        qqaiCoverThreeColX(col),
        row * (qqaiCoverStyle4RowH + qqaiCoverGap),
        qqaiCoverThreeColWidths[col],
        qqaiCoverStyle4RowH,
      );
    }
  }
  return Uint8List.fromList(img.encodePng(canvas));
}

img.Image _createCoverCanvas() {
  final canvas = img.Image(width: qqaiStyledCoverW, height: qqaiStyledCoverH);
  img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
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
