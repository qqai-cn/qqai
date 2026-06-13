import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

import 'media_video_cache_backend.dart';
import 'media_video_cache_partial_download.dart';

class IoMediaVideoCacheBackend implements MediaVideoCacheBackend {
  IoMediaVideoCacheBackend()
      : _manager = CacheManager(
          Config(
            'qqai_media_video',
            stalePeriod: const Duration(days: 7),
            maxNrOfCacheObjects: 24,
          ),
        );

  final CacheManager _manager;
  final Dio _dio = Dio();
  final Map<String, Future<File?>> _inflight = {};

  @override
  void precache(String resolved, String storageKey) {
    unawaited(_downloadToCache(resolved, storageKey: storageKey));
  }

  @override
  Future<VideoPlayerController> createController(
    String resolved,
    String storageKey, {
    Duration? waitForCache,
  }) async {
    final cached = await _fileFromCache(storageKey);
    if (cached != null) {
      return VideoPlayerController.file(cached);
    }
    final downloaded = await _downloadToCache(
      resolved,
      storageKey: storageKey,
      timeout: waitForCache,
    );
    if (downloaded != null) {
      return VideoPlayerController.file(downloaded);
    }
    return VideoPlayerController.networkUrl(Uri.parse(resolved));
  }

  Future<File?> _fileFromCache(String storageKey) async {
    final info = await _manager.getFileFromCache(storageKey);
    return info?.file;
  }

  Future<File?> _downloadToCache(
    String resolved, {
    required String storageKey,
    Duration? timeout,
  }) async {
    final existing = await _manager.getFileFromCache(storageKey);
    if (existing != null) return existing.file;

    final downloadFuture = _inflight.putIfAbsent(
      storageKey,
      () {
        final future = _downloadPartial(resolved, storageKey);
        future.whenComplete(() => _inflight.remove(storageKey));
        return future;
      },
    );

    try {
      return timeout == null
          ? await downloadFuture
          : await downloadFuture.timeout(timeout);
    } on TimeoutException {
      return null;
    } catch (e, st) {
      debugPrint('MediaVideoCache IO download failed: $e\n$st');
      return null;
    }
  }

  Future<File?> _downloadPartial(String resolved, String storageKey) async {
    final bytes = await downloadPartialVideoPrefix(_dio, resolved);
    if (bytes == null) return null;
    final file = await _manager.putFile(
      resolved,
      bytes,
      key: storageKey,
      fileExtension: videoCacheFileExtension(resolved),
    );
    return file;
  }
}

MediaVideoCacheBackend createMediaVideoCacheBackend() =>
    IoMediaVideoCacheBackend();
