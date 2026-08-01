import 'dart:js_interop';

import 'package:dio/dio.dart' show Dio;
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import 'media_video_cache_policy.dart';

/// Web：用浏览器 fetch（勿手动设 Referer，避免 XHR/CORS 预检失败）。
/// 防盗链依赖页面自然 Referer（如 https://aabe.cn）。
Future<Uint8List?> downloadPartialVideoPrefix(
  Dio dio,
  String url, {
  Map<String, String>? headers,
}) async {
  if (MediaVideoCachePolicy.isStreamManifest(url)) {
    return null;
  }
  if (url.startsWith('blob:') || url.startsWith('data:')) {
    return null;
  }

  final range = MediaVideoCachePolicy.rangeHeaderValue(null);

  try {
    return await _fetchRange(url, range: range, extraHeaders: headers);
  } catch (e) {
    if (kDebugMode) {
      debugPrint('downloadPartialVideoPrefix (web) failed: $e');
    }
    return null;
  }
}

Future<Uint8List?> _fetchRange(
  String url, {
  required String? range,
  Map<String, String>? extraHeaders,
}) async {
  final hdrs = web.Headers();
  if (range != null) {
    hdrs.append('Range', range);
  }
  extraHeaders?.forEach((key, value) {
    final lower = key.toLowerCase();
    if (lower == 'referer' || lower == 'range') return;
    hdrs.append(key, value);
  });

  final response = await web.window
      .fetch(
        url.toJS,
        web.RequestInit(
          method: 'GET',
          headers: hdrs,
          mode: 'cors',
          credentials: 'omit',
          referrerPolicy: 'strict-origin-when-cross-origin',
        ),
      )
      .toDart;

  final status = response.status;
  if (status != 200 && status != 206) {
    return null;
  }

  final jsBytes = await response.bytes().toDart;
  final bytes = jsBytes.toDart;
  if (bytes.isEmpty) return null;
  return bytes;
}
