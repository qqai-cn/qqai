import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image/image.dart' as img;

import 'video_cover_frame_result.dart';
import 'video_cover_sampling.dart';

Future<CoverStyleFramesResult> extractCoverStyleFrames({
  required String videoPath,
  List<int>? timePointsMs,
  required int styleId,
  required int durationHintMs,
  required int maxWidth,
  required int batchSize,
  void Function(int index, img.Image frame)? onFrameExtracted,
}) async {
  final points = timePointsMs ??
      computeCoverStyleTimePoints(durationHintMs, styleId);
  final frames = <img.Image?>[];
  for (var start = 0; start < points.length; start += batchSize) {
    final end = (start + batchSize).clamp(0, points.length);
    final batchTimes = points.sublist(start, end);
    final batch = await Future.wait(
      batchTimes.map(
        (timeMs) => _extractCoverFrame(
          videoPath: videoPath,
          timeMs: timeMs,
          maxWidth: maxWidth,
        ),
      ),
    );
    for (var i = 0; i < batch.length; i++) {
      final frame = batch[i];
      frames.add(frame);
      if (frame != null) {
        onFrameExtracted?.call(start + i, frame);
      }
    }
  }
  return CoverStyleFramesResult(frames: frames);
}

Future<img.Image?> _extractCoverFrame({
  required String videoPath,
  required int timeMs,
  required int maxWidth,
}) async {
  final bytes = await VideoThumbnail.thumbnailData(
    video: videoPath,
    imageFormat: ImageFormat.JPEG,
    maxHeight: 0,
    maxWidth: maxWidth,
    timeMs: timeMs,
    quality: 85,
  );
  return img.decodeImage(bytes);
}
