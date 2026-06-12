import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:qqai/util/media_url.dart';
import 'package:qqai/util/media_video_cache.dart';
import 'package:video_player/video_player.dart';

class SharedVideoPlaybackSession {
  SharedVideoPlaybackSession._(this.sessionKey, this.videoController) {
    flickManager = FlickManager(
      videoPlayerController: videoController,
      autoPlay: false,
      autoInitialize: true,
    );
  }

  final String sessionKey;
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
    _sessions.remove(sessionKey);
    flickManager.dispose();
  }
}

class _SessionSlot {
  SharedVideoPlaybackSession? session;
  Future<SharedVideoPlaybackSession>? pending;
}

final Map<String, _SessionSlot> _sessions = {};

/// [sessionKey] 默认 [mediaCacheKey]，与磁盘缓存键一致，签名 URL 轮换仍可复用会话。
Future<SharedVideoPlaybackSession> acquireSharedVideoPlaybackSession({
  required String playbackUrl,
  String? sessionKey,
}) async {
  final key = sessionKey ?? mediaCacheKey(playbackUrl);
  final slot = _sessions.putIfAbsent(key, () => _SessionSlot());

  final existing = slot.session;
  if (existing != null && !existing.isIdleWithError) {
    existing.retain();
    return existing;
  }
  if (existing?.isIdleWithError == true) {
    existing!.dispose();
    slot.session = null;
  }

  if (slot.pending != null) {
    final session = await slot.pending!;
    session.retain();
    return session;
  }

  slot.pending = _createSession(key, playbackUrl);
  try {
    final session = await slot.pending!;
    slot.session = session;
    slot.pending = null;
    session.retain();
    return session;
  } catch (e) {
    slot.pending = null;
    rethrow;
  }
}

Future<SharedVideoPlaybackSession> _createSession(
  String sessionKey,
  String playbackUrl,
) async {
  final controller = await createVideoPlayerController(playbackUrl);
  return SharedVideoPlaybackSession._(sessionKey, controller);
}

/// 丢弃空闲中的共享会话（例如加载失败后重试）。
void invalidateSharedVideoPlaybackSession(String playbackUrlOrKey) {
  final key = playbackUrlOrKey.contains('?')
      ? mediaCacheKey(playbackUrlOrKey)
      : playbackUrlOrKey;
  final session = _sessions[key]?.session;
  if (session == null || !session.isIdle) return;
  session.dispose();
}
