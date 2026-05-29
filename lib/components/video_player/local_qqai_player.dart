import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qqai/components/video_player/safe_flick_video_player.dart';
import 'package:video_player/video_player.dart';

/// 供父组件读取本地播放器当前进度（如截取封面帧）。
class LocalQqaiPlayerController {
  FlickManager? _manager;

  void attach(FlickManager manager) => _manager = manager;

  void detach() => _manager = null;

  VideoPlayerValue? get _value =>
      _manager?.flickVideoManager?.videoPlayerValue;

  Duration? get position {
    final value = _value;
    if (value == null || !value.isInitialized) return null;
    return value.position;
  }

  Duration? get duration {
    final value = _value;
    if (value == null || !value.isInitialized) return null;
    return value.duration;
  }

  bool get isReady => _value?.isInitialized == true;
}

/// 本地文件视频播放器，与 [QqaiPlayer] 共用 Flick 控件（如 [ItemControls]）。
class LocalQqaiPlayer extends StatefulWidget {
  const LocalQqaiPlayer({
    super.key,
    required this.file,
    required this.controls,
    this.playerController,
    this.autoPlay = false,
    this.videoFit = BoxFit.contain,
  });

  final XFile file;
  final Widget controls;
  final LocalQqaiPlayerController? playerController;
  final bool autoPlay;
  final BoxFit videoFit;

  @override
  State<LocalQqaiPlayer> createState() => _LocalQqaiPlayerState();
}

class _LocalQqaiPlayerState extends State<LocalQqaiPlayer> {
  FlickManager? _flickManager;
  Object? _initError;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  void didUpdateWidget(LocalQqaiPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.path != widget.file.path) {
      _disposePlayer();
      _initError = null;
      _initPlayer();
    }
  }

  Future<void> _initPlayer() async {
    final controller = createVideoControllerFromXFile(widget.file);
    try {
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      final manager = FlickManager(
        videoPlayerController: controller,
        autoPlay: widget.autoPlay,
        autoInitialize: true,
      );
      widget.playerController?.attach(manager);
      setState(() {
        _flickManager = manager;
        _initError = null;
      });
    } catch (e) {
      await controller.dispose();
      if (mounted) {
        setState(() => _initError = e);
      }
    }
  }

  void _disposePlayer() {
    widget.playerController?.detach();
    _flickManager?.dispose();
    _flickManager = null;
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initError != null) {
      return Container(
        color: const Color(0xFF1F2937),
        alignment: Alignment.center,
        child: const Icon(
          Icons.videocam_off_outlined,
          color: Colors.white54,
          size: 36,
        ),
      );
    }

    final manager = _flickManager;
    if (manager == null) {
      return Container(
        color: const Color(0xFF1F2937),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white70,
        ),
      );
    }

    return SafeFlickVideoPlayer(
      flickManager: manager,
      wakelockEnabled: false,
      flickVideoWithControls: FlickVideoWithControls(
        videoFit: widget.videoFit,
        playerLoadingFallback: const ColoredBox(
          color: Color(0xFF1F2937),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white70,
            ),
          ),
        ),
        controls: widget.controls,
      ),
    );
  }
}

VideoPlayerController createVideoControllerFromXFile(XFile file) {
  final path = file.path;
  final uri = Uri.tryParse(path);
  if (uri != null && uri.hasScheme && uri.scheme != 'file') {
    return VideoPlayerController.networkUrl(uri);
  }
  if (kIsWeb) {
    return VideoPlayerController.networkUrl(uri ?? Uri.parse(path));
  }
  return VideoPlayerController.file(File(uri?.toFilePath() ?? path));
}
