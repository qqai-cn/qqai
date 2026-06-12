import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/util/media_url.dart';
import 'package:qqai/util/media_video_cache.dart';

/// 按顺序预缓存若干条视频 URL（常用于「下一条」「下两条」）。
void precacheUpcomingVideoUrls(
  Iterable<String?> urls, {
  int maxCount = 2,
}) {
  var count = 0;
  for (final raw in urls) {
    if (count >= maxCount) break;
    final resolved = resolveMediaUrl(raw);
    if (resolved == null || resolved.isEmpty) continue;
    precacheVideo(resolved);
    count++;
  }
}

/// 预缓存 Feed 中当前条之后的视频（[currentIndex] 为正在观看/聚焦的索引）。
void precacheUpcomingBlogVideos(
  List<BlogItem> items, {
  required int currentIndex,
  int aheadCount = 2,
}) {
  if (items.isEmpty || aheadCount <= 0) return;
  final urls = <String?>[];
  for (
    var i = currentIndex + 1;
    i < items.length && urls.length < aheadCount;
    i++
  ) {
    final raw = firstPlayableVideoUrlFromResources(items[i].resources);
    urls.add(resolveMediaUrl(raw));
  }
  precacheUpcomingVideoUrls(urls, maxCount: aheadCount);
}

/// 同一动态多段视频：预缓存当前段之后的分集。
void precacheUpcomingBlogSegments(
  String? resources, {
  required int currentSegmentIndex,
  int aheadCount = 1,
}) {
  if (aheadCount <= 0) return;
  final segments = playableVideoUrlsFromResources(resources)
      .map(resolveMediaUrl)
      .whereType<String>()
      .where((url) => url.isNotEmpty)
      .toList();
  if (currentSegmentIndex + 1 >= segments.length) return;
  precacheUpcomingVideoUrls(
    segments.skip(currentSegmentIndex + 1),
    maxCount: aheadCount,
  );
}

/// 从列表项解析可预缓存的视频 URL（非视频返回 null）。
String? blogItemVideoUrlForPrecache(BlogItem item) {
  if (item.blogType != 2) return null;
  final raw = firstPlayableVideoUrlFromResources(item.resources);
  return resolveMediaUrl(raw);
}
