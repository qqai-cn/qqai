import 'package:qqai/components/video_player/video_ad_overlay.dart';

import 'blog_page_parse.dart';
import 'models/blog_page_model.dart';

class BlogDetailRouteExtra {
  const BlogDetailRouteExtra({
    required this.blogItem,
    this.mediaHeroTag,
    this.videoAdState,
  });

  final BlogItem blogItem;
  final String? mediaHeroTag;
  final VideoAdPlaybackState? videoAdState;
}

class ParsedBlogDetailRouteExtra {
  const ParsedBlogDetailRouteExtra({
    required this.blogItem,
    this.mediaHeroTag,
    this.videoAdState,
  });

  final BlogItem blogItem;
  final String? mediaHeroTag;
  final VideoAdPlaybackState? videoAdState;
}

/// 解析 go_router [extra]：支持 [BlogItem] 与 JSON Map（Web 热重启后常见）。
BlogItem? parseBlogItemRouteExtra(Object? extra) {
  return parseBlogDetailRouteExtra(extra)?.blogItem;
}

ParsedBlogDetailRouteExtra? parseBlogDetailRouteExtra(Object? extra) {
  if (extra == null) return null;
  if (extra is BlogDetailRouteExtra) {
    return ParsedBlogDetailRouteExtra(
      blogItem: extra.blogItem,
      mediaHeroTag: extra.mediaHeroTag,
      videoAdState: extra.videoAdState,
    );
  }
  if (extra is BlogItem) {
    return ParsedBlogDetailRouteExtra(blogItem: extra);
  }
  if (extra is Map) {
    final map = extra is Map<String, dynamic>
        ? extra
        : Map<String, dynamic>.from(extra);
    final rawBlog = map['blogItem'] ?? map['blog'] ?? map['item'];
    final heroTag = map['mediaHeroTag'] as String?;
    final videoAdState = _parseVideoAdPlaybackState(map['videoAdState']);
    if (rawBlog is Map) {
      final blogMap = rawBlog is Map<String, dynamic>
          ? rawBlog
          : Map<String, dynamic>.from(rawBlog);
      return ParsedBlogDetailRouteExtra(
        blogItem: BlogItem.fromJson(normalizeBlogItemJson(blogMap)),
        mediaHeroTag: heroTag,
        videoAdState: videoAdState,
      );
    }
    return ParsedBlogDetailRouteExtra(
      blogItem: BlogItem.fromJson(normalizeBlogItemJson(map)),
      mediaHeroTag: heroTag,
      videoAdState: videoAdState,
    );
  }
  return null;
}

VideoAdPlaybackState? _parseVideoAdPlaybackState(Object? raw) {
  if (raw is VideoAdPlaybackState) return raw;
  if (raw is Map) {
    return VideoAdPlaybackState.fromJson(Map<String, dynamic>.from(raw));
  }
  return null;
}

/// 列表项 Hero 作用域，避免同页重复 [blog.id] 时 tag 冲突。
String blogFeedListItemHeroScope({
  required int category,
  required int listIndex,
  String? prefix,
}) {
  final head = prefix ?? 'feed';
  return '$head-$category-$listIndex';
}

String blogImageDetailHeroTag(
  int category,
  BlogItem blog, {
  int index = 0,
  String? scope,
}) {
  final id = blog.id ?? identityHashCode(blog);
  if (scope != null && scope.isNotEmpty) {
    return 'lookBlogImg-$scope-$category-$id-$index';
  }
  return 'lookBlogImg-$category-$id-$index';
}

String blogVideoDetailHeroTag(int category, BlogItem blog) {
  final id = blog.id ?? identityHashCode(blog);
  return 'lookBlogVideo-$category-$id';
}

BlogDetailRouteExtra blogDetailRouteExtra(
  BlogItem blog, {
  String? mediaHeroTag,
  VideoAdPlaybackState? videoAdState,
}) {
  return BlogDetailRouteExtra(
    blogItem: blog,
    mediaHeroTag: mediaHeroTag,
    videoAdState: videoAdState,
  );
}
