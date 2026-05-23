import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image/image.dart' as img;

Future<List<img.Image?>> extractCoverStyleFrames({
  required String videoPath,
  required List<int> timePointsMs,
  required int maxWidth,
  required int batchSize,
}) async {
  final frames = <img.Image?>[];
  for (var start = 0; start < timePointsMs.length; start += batchSize) {
    final end = (start + batchSize).clamp(0, timePointsMs.length);
    final batch = await Future.wait(
      timePointsMs
          .sublist(start, end)
          .map(
            (timeMs) => _extractCoverFrame(
              videoPath: videoPath,
              timeMs: timeMs,
              maxWidth: maxWidth,
            ),
          ),
    );
    frames.addAll(batch);
  }
  return frames;
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
