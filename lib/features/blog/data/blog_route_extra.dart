import 'blog_page_parse.dart';
import 'models/blog_page_model.dart';

/// 解析 go_router [extra]：支持 [BlogItem] 与 JSON Map（Web 热重启后常见）。
BlogItem? parseBlogItemRouteExtra(Object? extra) {
  if (extra == null) return null;
  if (extra is BlogItem) return extra;
  if (extra is Map) {
    final map = extra is Map<String, dynamic>
        ? extra
        : Map<String, dynamic>.from(extra);
    return BlogItem.fromJson(normalizeBlogItemJson(map));
  }
  return null;
}
