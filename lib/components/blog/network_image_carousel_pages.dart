import 'package:flutter/material.dart';
import 'package:qqai/constant/constant.dart';

import '../../features/blog/data/models/blog_page_model.dart';
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

/// 从动态 [resources] 中解析全部可播放视频 URL。
List<String> playableVideoUrlsFromResources(String? raw) {
  final urls = parseCommaSeparatedUrls(raw);
  if (urls.isEmpty) {
    final t = raw?.trim();
    return (t != null && t.isNotEmpty) ? [t] : [];
  }
  final videos = urls.where(_looksLikeVideoUrl).toList();
  return videos.isNotEmpty ? videos : [urls.first];
}

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
      lower.endsWith('.svg') ||
      lower.endsWith('.webp') ||
      lower.endsWith('.gif');
}

String normalizeDefaultCoverAsset(String url) {
  final trimmed = url.trim();
  final path = trimmed.toLowerCase().split('?').first.split('#').first;
  if (path == 'defbak.png' || path.endsWith('/defbak.png')) {
    return Constant.DEFAULT_IMAGE_PLACEHOLDER;
  }
  return trimmed;
}

/// 从动态 [resources] 中取首条可播放视频 URL（逗号分隔时优先常见视频后缀）。
String? firstPlayableVideoUrlFromResources(String? raw) {
  final urls = playableVideoUrlsFromResources(raw);
  return urls.isEmpty ? null : urls.first;
}

/// 封面：优先取图片后缀的 URL，否则 [fallback]。
String? firstStillImageUrlFromResources(String? raw, {String? fallback}) {
  for (final u in parseCommaSeparatedUrls(raw)) {
    if (_looksLikeImageUrl(u)) return u;
  }
  return fallback;
}

/// 默认视频封面（无封面字段且无 resources 内图片时使用）。
const String kDefaultBlogVideoCoverUrl = Constant.DEFAULT_IMAGE_PLACEHOLDER;

/// 解析博客封面：优先 [coverUrl]，其次 resources 内图片，最后默认图。
String resolveBlogCoverUrlFromFields({
  String? coverUrl,
  String? resources,
  String fallback = kDefaultBlogVideoCoverUrl,
}) {
  final direct = coverUrl?.trim();
  if (direct != null && direct.isNotEmpty) {
    return normalizeDefaultCoverAsset(direct);
  }
  final resolved =
      firstStillImageUrlFromResources(resources, fallback: fallback) ??
      fallback;
  return normalizeDefaultCoverAsset(resolved);
}

/// [BlogItem] 封面解析。
String resolveBlogCoverUrl(
  BlogItem item, {
  String fallback = kDefaultBlogVideoCoverUrl,
}) {
  return resolveBlogCoverUrlFromFields(
    coverUrl: item.coverUrl,
    resources: item.resources,
    fallback: fallback,
  );
}

/// 全屏轮播子页：圆角网络图 + 加载/错误占位。
List<Widget> buildNetworkImageCarouselPages(
  List<String> imageUrls, {
  String? firstHeroTag,
  BoxFit fit = BoxFit.cover,
}) {
  return imageUrls.asMap().entries.map((entry) {
    final index = entry.key;
    final url = entry.value;
    final image = Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: QqNetworkImage(
        url: url,
        fit: fit,
        borderRadius: BorderRadius.circular(8),
      ),
    );
    if (index == 0 && firstHeroTag != null && firstHeroTag.isNotEmpty) {
      return Hero(tag: firstHeroTag, child: image);
    }
    return image;
  }).toList();
}
