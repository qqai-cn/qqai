import 'package:flutter/material.dart';

import '../qq_network_image.dart';

/// 逗号分隔资源字段 → URL 列表。
List<String> parseCommaSeparatedUrls(String? raw) {
  return raw
          ?.split(',')
          .map((url) => url.trim())
          .where((url) => url.isNotEmpty)
          .toList() ??
      [];
}

bool isPlayableVideoResourceUrl(String u) => _looksLikeVideoUrl(u);

bool blogItemHasVideoResources(String? raw) =>
    parseCommaSeparatedUrls(raw).any(isPlayableVideoResourceUrl);

bool _looksLikeVideoUrl(String u) {
  final lower = u.toLowerCase();
  return lower.endsWith('.mp4') ||
      lower.endsWith('.m3u8') ||
      lower.endsWith('.mov') ||
      lower.endsWith('.webm');
}

bool _looksLikeImageUrl(String u) {
  final lower = u.toLowerCase();
  return lower.endsWith('.jpg') ||
      lower.endsWith('.jpeg') ||
      lower.endsWith('.png') ||
      lower.endsWith('.webp') ||
      lower.endsWith('.gif');
}

/// 从动态 [resources] 中取首条可播放视频 URL（逗号分隔时优先常见视频后缀）。
String? firstPlayableVideoUrlFromResources(String? raw) {
  final urls = parseCommaSeparatedUrls(raw);
  if (urls.isEmpty) {
    final t = raw?.trim();
    return (t != null && t.isNotEmpty) ? t : null;
  }
  for (final u in urls) {
    if (_looksLikeVideoUrl(u)) return u;
  }
  return urls.first;
}

/// 封面：优先取图片后缀的 URL，否则 [fallback]。
String? firstStillImageUrlFromResources(String? raw, {String? fallback}) {
  for (final u in parseCommaSeparatedUrls(raw)) {
    if (_looksLikeImageUrl(u)) return u;
  }
  return fallback;
}

/// 全屏轮播子页：圆角网络图 + 加载/错误占位。
List<Widget> buildNetworkImageCarouselPages(List<String> imageUrls) {
  return imageUrls.map((url) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: QqNetworkImage(
        url: url,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }).toList();
}
