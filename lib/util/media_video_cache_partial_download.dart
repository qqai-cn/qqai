import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'media_video_cache_partial_download_io.dart'
    if (dart.library.js_interop) 'media_video_cache_partial_download_web.dart'
    as impl;

/// 防盗链 Referer（file.aabe.cn，仅原生 Dio 请求使用）。
const kMediaVideoCacheReferer = 'https://qqai.cn/';

/// 下载视频前缀：最多约 [MediaVideoCachePolicy.maxCachedDuration]（HTTP Range）。
Future<Uint8List?> downloadPartialVideoPrefix(
  Dio dio,
  String url, {
  Map<String, String>? headers,
}) {
  return impl.downloadPartialVideoPrefix(dio, url, headers: headers);
}

String videoCacheFileExtension(String url) {
  final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
  if (path.endsWith('.webm')) return 'webm';
  if (path.endsWith('.mov')) return 'mov';
  return 'mp4';
}
