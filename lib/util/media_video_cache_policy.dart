import 'dart:math';

/// 视频磁盘/IndexedDB 缓存策略：每条仅保留约前 [maxCachedDuration] 内容。
class MediaVideoCachePolicy {
  MediaVideoCachePolicy._();

  static const Duration maxCachedDuration = Duration(minutes: 10);

  /// 按 ~1.6 Mbps 估算 10 分钟体积（约 120 MB）；短视频小于该值则整段缓存。
  static const int estimatedBytesPerSecond = 200 * 1024;

  static int get maxPartialBytes =>
      maxCachedDuration.inSeconds * estimatedBytesPerSecond;

  /// 实际下载上限：不超过文件总长，也不超过 10 分钟估算值。
  static int effectiveMaxBytes(int? contentLength) {
    final cap = maxPartialBytes;
    if (contentLength == null || contentLength <= 0) return cap;
    return min(contentLength, cap);
  }

  /// 是否需要 Range 前缀下载（文件大于策略上限时才截断）。
  static bool shouldUseRangeRequest(int? contentLength) {
    if (contentLength == null || contentLength <= 0) return true;
    return contentLength > maxPartialBytes;
  }

  static String? rangeHeaderValue(int? contentLength) {
    if (!shouldUseRangeRequest(contentLength)) return null;
    final end = effectiveMaxBytes(contentLength) - 1;
    return 'bytes=0-$end';
  }

  static bool isStreamManifest(String url) {
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
    return path.endsWith('.m3u8');
  }
}
