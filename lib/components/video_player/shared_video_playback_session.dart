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
    _disposeTimer = Timer(const Duration(seconds: 30), dispose);
  }

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
  final session = _sessions[url] ??= SharedVideoPlaybackSession._(url);
  session.retain();
  return session;
}
