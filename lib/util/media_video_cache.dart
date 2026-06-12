import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:qqai/util/media_url.dart';
import 'package:video_player/video_player.dart';

/// file.qqai.cn 等媒体视频的磁盘预缓存（Web 端跳过，依赖浏览器 HTTP 缓存）。
class MediaVideoCache {
  MediaVideoCache._();

  static final MediaVideoCache instance = MediaVideoCache._();

  static const _cacheName = 'qqai_media_video';

  final CacheManager _manager = CacheManager(
    Config(
      _cacheName,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 24,
    ),
  );

  final Set<String> _downloading = {};

  String storageKey(String url) => mediaCacheKey(url);

  /// 列表可见时后台预拉取；已缓存或正在下载则跳过。
  void precache(String? url) {
    if (kIsWeb) return;
    final resolved = _resolve(url);
    if (resolved == null) return;
    final key = storageKey(resolved);
    if (_downloading.contains(key)) return;
    _downloading.add(key);
    unawaited(() async {
      try {
        final existing = await _manager.getFileFromCache(key);
        if (existing == null) {
          await _manager.downloadFile(resolved, key: key);
        }
      } catch (e, st) {
        debugPrint('MediaVideoCache.precache failed: $e\n$st');
      } finally {
        _downloading.remove(key);
      }
    }());
  }

  Future<File?> getFileIfCached(String url) async {
    if (kIsWeb) return null;
    final resolved = _resolve(url);
    if (resolved == null) return null;
    final info = await _manager.getFileFromCache(storageKey(resolved));
    return info?.file;
  }

  /// 优先本地文件；未命中则网络播放并后台落盘供下次使用。
  Future<VideoPlayerController> createController(String url) async {
    final resolved = _resolve(url);
    if (resolved == null) {
      throw ArgumentError.value(url, 'url', 'not a playable media url');
    }
    if (!kIsWeb) {
      final cached = await getFileIfCached(resolved);
      if (cached != null) {
        return VideoPlayerController.file(cached);
      }
      precache(resolved);
    }
    return VideoPlayerController.networkUrl(Uri.parse(resolved));
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
