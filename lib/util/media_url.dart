import '../constant/api_constant.dart';

/// 将接口返回的资源路径转为可加载的完整 URL。
String? resolveMediaUrl(String? raw) {
  if (raw == null) return null;
  final s = raw.trim();
  if (s.isEmpty) return null;
  if (s.startsWith('http://') || s.startsWith('https://')) {
    return s;
  }
  if (s.startsWith('//')) {
    return 'https:$s';
  }
  if (s.startsWith('/')) {
    return '${ApiConstant.BASE_URL}$s';
  }
  return s;
}

bool hasResolvableMediaUrl(String? raw) => resolveMediaUrl(raw) != null;

/// 磁盘/内存缓存键：去掉 secure_link 的 ?e=&token=，避免每次 API 重签导致缓存失效。
String mediaCacheKey(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || uri.query.isEmpty) return url;
  return uri.replace(queryParameters: {}).toString();
}
