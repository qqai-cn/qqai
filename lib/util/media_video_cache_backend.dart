import 'package:video_player/video_player.dart';

/// 平台实现由 conditional import 注入（IO 文件 / Web IndexedDB + Blob）。
abstract class MediaVideoCacheBackend {
  void precache(String resolved, String storageKey);

  Future<VideoPlayerController> createController(
    String resolved,
    String storageKey, {
    Duration? waitForCache,
  });
}

MediaVideoCacheBackend createMediaVideoCacheBackend() {
  throw UnsupportedError('MediaVideoCache is not available on this platform');
}
