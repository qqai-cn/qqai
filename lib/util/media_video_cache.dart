import 'package:flutter/foundation.dart';
import 'package:qqai/util/media_url.dart';
import 'package:video_player/video_player.dart';

import 'media_video_cache_backend.dart';
import 'media_video_cache_backend_io.dart'
    if (dart.library.js_interop) 'media_video_cache_backend_web.dart'
    as impl;

/// file.qqai.cn 媒体视频预缓存：App 落盘文件，Web IndexedDB + Blob URL。
class MediaVideoCache {
  MediaVideoCache._();

  static final MediaVideoCache instance = MediaVideoCache._();

  /// App：播放时短暂等缓存；Web：仅命中 IndexedDB 即用，否则立刻走网络（预缓存后台继续）。
  static Duration get playbackWaitForCache =>
      kIsWeb ? Duration.zero : const Duration(seconds: 2);

  final MediaVideoCacheBackend _backend = impl.createMediaVideoCacheBackend();

  String storageKey(String url) => mediaCacheKey(url);

  void precache(String? url) {
    final resolved = _resolve(url);
    if (resolved == null) return;
    _backend.precache(resolved, storageKey(resolved));
  }

  Future<VideoPlayerController> createController(String url) {
    final resolved = _resolve(url);
    if (resolved == null) {
      throw ArgumentError.value(url, 'url', 'not a playable media url');
    }
    return _backend.createController(
      resolved,
      storageKey(resolved),
      waitForCache: playbackWaitForCache,
    );
  }

  String? _resolve(String? url) {
    if (url == null) return null;
    final trimmed = url.trim();
    if (trimmed.isEmpty) return null;
    return resolveMediaUrl(trimmed) ?? trimmed;
  }
}

void precacheVideo(String? url) => MediaVideoCache.instance.precache(url);

Future<VideoPlayerController> createVideoPlayerController(String url) {
  return MediaVideoCache.instance.createController(url);
}
