import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class SharedVideoPlaybackSession {
  SharedVideoPlaybackSession._(this.url)
    : videoController = VideoPlayerController.networkUrl(Uri.parse(url)) {
    flickManager = FlickManager(
      videoPlayerController: videoController,
      autoPlay: false,
      autoInitialize: true,
    );
  }

  final String url;
  final VideoPlayerController videoController;
  late final FlickManager flickManager;

  int _refCount = 0;
  Timer? _disposeTimer;
  bool _disposed = false;

  void retain() {
    _disposeTimer?.cancel();
    _disposeTimer = null;
    _refCount++;
  }

  void release() {
    _refCount--;
    if (_refCount > 0 || _disposed) return;
    _disposeTimer?.cancel();
    flickManager.flickControlManager?.autoPause();
    if (videoController.value.isInitialized) {
      videoController.pause();
    }
    if (videoController.value.hasError) {
      dispose();
      return;
    }
    _disposeTimer = Timer(const Duration(seconds: 30), dispose);
  }

  bool get isIdleWithError =>
      _refCount == 0 && !_disposed && videoController.value.hasError;

  bool get isIdle => _refCount == 0 && !_disposed;

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _disposeTimer?.cancel();
    _sessions.remove(url);
    flickManager.dispose();
  }
}

final Map<String, SharedVideoPlaybackSession> _sessions = {};

SharedVideoPlaybackSession acquireSharedVideoPlaybackSession(String url) {
  final existing = _sessions[url];
  if (existing != null && existing.isIdleWithError) {
    existing.dispose();
    _sessions.remove(url);
  }
  final session = _sessions[url] ??= SharedVideoPlaybackSession._(url);
  session.retain();
  return session;
}

/// 丢弃空闲中的共享会话（例如加载失败后重试）。
void invalidateSharedVideoPlaybackSession(String url) {
  final session = _sessions[url];
  if (session == null || !session.isIdle) return;
  session.dispose();
}
