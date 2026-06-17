import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'media_video_cache_partial_download.dart';
import 'media_video_cache_policy.dart';

/// 原生端：Dio + Referer + Range 前缀下载。
Future<Uint8List?> downloadPartialVideoPrefix(
  Dio dio,
  String url, {
  Map<String, String>? headers,
}) async {
  if (MediaVideoCachePolicy.isStreamManifest(url)) {
    return null;
  }

  final requestHeaders = <String, String>{
    'Referer': kMediaVideoCacheReferer,
    ...?headers,
  };

  int? contentLength;
  try {
    final head = await dio.head(
      url,
      options: Options(
        headers: requestHeaders,
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (head.statusCode == 200 || head.statusCode == 206) {
      contentLength = int.tryParse(head.headers.value('content-length') ?? '');
    }
  } catch (_) {
    // 部分 CDN 不支持 HEAD，继续尝试 Range GET
  }

  final range = MediaVideoCachePolicy.rangeHeaderValue(contentLength);
  final getHeaders = Map<String, String>.from(requestHeaders);
  if (range != null) {
    getHeaders['Range'] = range;
  }

  try {
    final response = await dio.get<List<int>>(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        headers: getHeaders,
        validateStatus: (status) => status == 200 || status == 206,
      ),
    );
    final data = response.data;
    if (data == null || data.isEmpty) return null;
    return Uint8List.fromList(data);
  } catch (e, st) {
    debugPrint('downloadPartialVideoPrefix failed: $e\n$st');
    return null;
  }
}
