import 'blog_page_parse.dart';
import 'models/blog_page_model.dart';

class BlogDetailRouteExtra {
  const BlogDetailRouteExtra({required this.blogItem, this.mediaHeroTag});

  final BlogItem blogItem;
  final String? mediaHeroTag;
}

class ParsedBlogDetailRouteExtra {
  const ParsedBlogDetailRouteExtra({required this.blogItem, this.mediaHeroTag});

  final BlogItem blogItem;
  final String? mediaHeroTag;
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
    if (rawBlog is Map) {
      final blogMap = rawBlog is Map<String, dynamic>
          ? rawBlog
          : Map<String, dynamic>.from(rawBlog);
      return ParsedBlogDetailRouteExtra(
        blogItem: BlogItem.fromJson(normalizeBlogItemJson(blogMap)),
        mediaHeroTag: heroTag,
      );
    }
    return ParsedBlogDetailRouteExtra(
      blogItem: BlogItem.fromJson(normalizeBlogItemJson(map)),
      mediaHeroTag: heroTag,
    );
  }
  return null;
}

String blogImageDetailHeroTag(int category, BlogItem blog, {int index = 0}) {
  final id = blog.id ?? identityHashCode(blog);
  return 'lookBlogImg-$category-$id-$index';
}

String blogVideoDetailHeroTag(int category, BlogItem blog) {
  final id = blog.id ?? identityHashCode(blog);
  return 'lookBlogVideo-$category-$id';
}

BlogDetailRouteExtra blogDetailRouteExtra(
  BlogItem blog, {
  String? mediaHeroTag,
}) {
  return BlogDetailRouteExtra(blogItem: blog, mediaHeroTag: mediaHeroTag);
}
