import 'dart:async';

import 'package:cross_cache/cross_cache.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:qqai/util/web_blob_helpers.dart';
import 'package:video_player/video_player.dart';

import 'media_video_cache_backend.dart';
import 'media_video_cache_partial_download.dart';

/// Web：IndexedDB（cross_cache）持久化 + Blob URL 播放。
class WebMediaVideoCacheBackend implements MediaVideoCacheBackend {
  WebMediaVideoCacheBackend();

  static const _maxObjects = 24;

  final CrossCache _cache = CrossCache();
  final Dio _dio = Dio();
  final Map<String, Future<Uint8List?>> _inflight = {};
  final Map<String, String> _blobUrlByKey = {};
  final List<String> _lruKeys = [];

  @override
  void precache(String resolved, String storageKey) {
    unawaited(_loadBytes(resolved, storageKey));
  }

  @override
  Future<VideoPlayerController> createController(
    String resolved,
    String storageKey, {
    Duration? waitForCache,
  }) async {
    final bytes = await _loadBytes(
      resolved,
      storageKey,
      timeout: waitForCache,
    );
    if (bytes != null) {
      final blobUrl = _blobUrlForKey(storageKey, bytes, resolved);
      return VideoPlayerController.networkUrl(Uri.parse(blobUrl));
    }
    return VideoPlayerController.networkUrl(Uri.parse(resolved));
  }

  String _blobUrlForKey(String storageKey, Uint8List bytes, String resolved) {
    final existing = _blobUrlByKey[storageKey];
    if (existing != null) return existing;
    final mime = _mimeFromUrl(resolved);
    final url = createBlobUrlFromBytes(bytes, mimeType: mime);
    _blobUrlByKey[storageKey] = url;
    return url;
  }

  /// [timeout] 为 null：等到下载完成（预缓存）。为 zero：仅读已有缓存，否则立刻 null。
  Future<Uint8List?> _loadBytes(
    String resolved,
    String storageKey, {
    Duration? timeout,
  }) async {
    try {
      if (await _cache.contains(storageKey)) {
        _touchLru(storageKey);
        return _cache.get(storageKey);
      }
    } catch (_) {}

    final skipWait = timeout != null && timeout <= Duration.zero;
    final inflight = _inflight[storageKey];

    if (inflight != null) {
      if (skipWait) return null;
      return _awaitWithTimeout(inflight, timeout);
    }

    final future = _startDownload(resolved, storageKey);
    if (skipWait) return null;
    return _awaitWithTimeout(future, timeout);
  }

  Future<Uint8List?> _startDownload(String resolved, String storageKey) {
    final future = _download(resolved, storageKey);
    _inflight[storageKey] = future;
    future.whenComplete(() => _inflight.remove(storageKey));
    return future;
  }

  Future<Uint8List?> _awaitWithTimeout(
    Future<Uint8List?> future,
    Duration? timeout,
  ) async {
    if (timeout == null) return future;
    try {
      return await future.timeout(timeout);
    } on TimeoutException {
      return null;
    }
  }

  Future<Uint8List?> _download(String resolved, String storageKey) async {
    final bytes = await downloadPartialVideoPrefix(_dio, resolved);
    if (bytes == null) return null;
    try {
      await _evictIfNeeded(excluding: storageKey);
      await _cache.set(storageKey, bytes);
      _touchLru(storageKey);
      return bytes;
    } catch (e, st) {
      debugPrint('MediaVideoCache Web store failed: $e\n$st');
      return null;
    }
  }

  void _touchLru(String key) {
    _lruKeys.remove(key);
    _lruKeys.add(key);
  }

  Future<void> _evictIfNeeded({String? excluding}) async {
    while (_lruKeys.length >= _maxObjects) {
      final victim = _lruKeys.firstWhere(
        (k) => k != excluding,
        orElse: () => '',
      );
      if (victim.isEmpty) break;
      _lruKeys.remove(victim);
      final blob = _blobUrlByKey.remove(victim);
      if (blob != null) revokeBlobUrlIfNeeded(blob);
      try {
        await _cache.delete(victim);
      } catch (_) {}
    }
  }

  String _mimeFromUrl(String url) {
    final path = Uri.parse(url).path.toLowerCase();
    if (path.endsWith('.webm')) return 'video/webm';
    if (path.endsWith('.mov')) return 'video/quicktime';
    if (path.endsWith('.m3u8')) return 'application/vnd.apple.mpegurl';
    return 'video/mp4';
  }
}

MediaVideoCacheBackend createMediaVideoCacheBackend() =>
    WebMediaVideoCacheBackend();
