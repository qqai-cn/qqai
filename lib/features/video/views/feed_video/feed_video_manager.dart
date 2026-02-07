import 'package:video_player/video_player.dart';

/// Feed 流视频管理器：同一时刻只播放一个视频
/// 默认静音以满足浏览器自动播放策略
class FeedVideoManager {
  final List<VideoPlayerController> _controllers = [];
  VideoPlayerController? _active;
  bool _muted = true;

  bool get isMuted => _muted;

  /// 注册播放器，若为第一个则自动播放
  void register(VideoPlayerController controller) {
    if (_controllers.contains(controller)) return;
    _controllers.add(controller);
    if (_controllers.length == 1) {
      _setActive(controller);
    }
  }

  /// 取消注册（调用方负责 dispose）
  void unregister(VideoPlayerController controller) {
    final idx = _controllers.indexOf(controller);
    if (idx < 0) return;
    if (_active == controller) _active = null;
    _controllers.removeAt(idx);
  }

  /// 指定播放此控制器，暂停其他
  void play(VideoPlayerController controller) {
    if (!_controllers.contains(controller)) return;
    _setActive(controller);
  }

  /// 暂停当前播放
  void pause() {
    _active?.pause();
  }

  /// 仅当指定控制器为当前激活时暂停
  void pauseIf(VideoPlayerController controller) {
    if (_active == controller) {
      controller.pause();
    }
  }

  void _setActive(VideoPlayerController controller) {
    _active?.pause();
    _active = controller;
    controller.setVolume(_muted ? 0 : 1);
    controller.play();
  }

  void toggleMute() {
    _muted = !_muted;
    for (final c in _controllers) {
      c.setVolume(_muted ? 0 : 1);
    }
  }
}
