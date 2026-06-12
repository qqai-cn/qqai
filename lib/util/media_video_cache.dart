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

  /// 播放时若预缓存仍在进行，最多等待此时长后改走网络流。
  static const Duration playbackWaitForCache = Duration(seconds: 2);

  final CacheManager _manager = CacheManager(
    Config(
      _cacheName,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 24,
    ),
  );

  final Map<String, Future<FileInfo>> _inflight = {};

  String storageKey(String url) => mediaCacheKey(url);

  /// 列表项进入视口时后台预拉取。
  void precache(String? url) {
    if (kIsWeb) return;
    final resolved = _resolve(url);
    if (resolved == null) return;
    unawaited(_downloadToCache(resolved));
  }

  Future<File?> getFileIfCached(String url) async {
    if (kIsWeb) return null;
    final resolved = _resolve(url);
    if (resolved == null) return null;
    final info = await _manager.getFileFromCache(storageKey(resolved));
    return info?.file;
  }

  /// 优先本地文件；预缓存进行中则短暂等待；否则网络播放并继续后台落盘。
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
      final downloaded = await _downloadToCache(
        resolved,
        timeout: playbackWaitForCache,
      );
      if (downloaded != null) {
        return VideoPlayerController.file(downloaded);
      }
    }
    return VideoPlayerController.networkUrl(Uri.parse(resolved));
  }

  Future<File?> _downloadToCache(
    String resolved, {
    Duration? timeout,
  }) async {
    final key = storageKey(resolved);
    final existing = await _manager.getFileFromCache(key);
    if (existing != null) return existing.file;

    final downloadFuture = _inflight.putIfAbsent(
      key,
      () => _manager
          .downloadFile(resolved, key: key)
          .whenComplete(() => _inflight.remove(key)),
    );

    try {
      final info = timeout == null
          ? await downloadFuture
          : await downloadFuture.timeout(timeout);
      return info.file;
    } on TimeoutException {
      return null;
    } catch (e, st) {
      debugPrint('MediaVideoCache download failed: $e\n$st');
      return null;
    }
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
