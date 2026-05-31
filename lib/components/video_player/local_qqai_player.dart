import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qqai/components/video_player/safe_flick_video_player.dart';
import 'package:qqai/components/video_player/video_aspect_ratio.dart';
import 'package:video_player/video_player.dart';

/// 供父组件读取本地播放器当前进度（如截取封面帧）。
class LocalQqaiPlayerController {
  FlickManager? _manager;

  void attach(FlickManager manager) => _manager = manager;

  void detach() => _manager = null;

  VideoPlayerValue? get _value => _manager?.flickVideoManager?.videoPlayerValue;

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
    this.fallbackAspectRatio = 15 / 9,
  });

  final XFile file;
  final Widget controls;
  final LocalQqaiPlayerController? playerController;
  final bool autoPlay;
  final BoxFit videoFit;
  final double fallbackAspectRatio;

  @override
  State<LocalQqaiPlayer> createState() => _LocalQqaiPlayerState();
}

class _LocalQqaiPlayerState extends State<LocalQqaiPlayer> {
  FlickManager? _flickManager;
  VideoPlayerController? _videoController;
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
        _videoController = controller;
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
    _videoController = null;
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

    final player = SafeFlickVideoPlayer(
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
    final controller = _videoController;
    if (controller == null) return player;
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return AspectRatio(
          aspectRatio: effectiveVideoAspectRatio(
            value,
            widget.fallbackAspectRatio,
          ),
          child: child!,
        );
      },
      child: player,
    );
  }
}

typedef LocalVideoAspectRatioBuilder =
    Widget Function(BuildContext context, double aspectRatio);

class LocalVideoAspectRatioBox extends StatefulWidget {
  const LocalVideoAspectRatioBox({
    super.key,
    required this.file,
    required this.builder,
    this.fallbackAspectRatio = 15 / 9,
  });

  final XFile file;
  final LocalVideoAspectRatioBuilder builder;
  final double fallbackAspectRatio;

  @override
  State<LocalVideoAspectRatioBox> createState() =>
      _LocalVideoAspectRatioBoxState();
}

class _LocalVideoAspectRatioBoxState extends State<LocalVideoAspectRatioBox> {
  double? _aspectRatio;
  int _loadVersion = 0;

  @override
  void initState() {
    super.initState();
    _aspectRatio = peekLocalVideoAspectRatio(widget.file.path);
    if (_aspectRatio == null) {
      _loadAspectRatio();
    }
  }

  @override
  void didUpdateWidget(LocalVideoAspectRatioBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.path != widget.file.path ||
        oldWidget.fallbackAspectRatio != widget.fallbackAspectRatio) {
      _aspectRatio = peekLocalVideoAspectRatio(widget.file.path);
      if (_aspectRatio == null) {
        _loadAspectRatio();
      }
    }
  }

  Future<void> _loadAspectRatio() async {
    final version = ++_loadVersion;
    final aspectRatio = await resolveLocalVideoAspectRatio(
      widget.file,
      fallbackAspectRatio: widget.fallbackAspectRatio,
    );
    if (!mounted || version != _loadVersion) return;
    if (_aspectRatio == aspectRatio) return;
    setState(() => _aspectRatio = aspectRatio);
  }

  @override
  void dispose() {
    _loadVersion++;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _aspectRatio ?? widget.fallbackAspectRatio);
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

class LocalVideoMetadata {
  const LocalVideoMetadata({
    required this.aspectRatio,
    required this.durationMs,
  });

  final double aspectRatio;
  final int durationMs;
}

final Map<String, double> _localVideoAspectRatioCache = {};

double? peekLocalVideoAspectRatio(String path) =>
    _localVideoAspectRatioCache[path];

Future<double> resolveLocalVideoAspectRatio(
  XFile file, {
  double fallbackAspectRatio = 15 / 9,
}) async {
  final cached = _localVideoAspectRatioCache[file.path];
  if (cached != null) return cached;

  final metadata = await resolveLocalVideoMetadata(
    file,
    fallbackAspectRatio: fallbackAspectRatio,
  );
  return metadata.aspectRatio;
}

Future<LocalVideoMetadata> resolveLocalVideoMetadata(
  XFile file, {
  double fallbackAspectRatio = 15 / 9,
}) async {
  final controller = createVideoControllerFromXFile(file);
  try {
    await controller.initialize();
    final aspectRatio = effectiveVideoAspectRatio(
      controller.value,
      fallbackAspectRatio,
    );
    _localVideoAspectRatioCache[file.path] = aspectRatio;
    return LocalVideoMetadata(
      aspectRatio: aspectRatio,
      durationMs: controller.value.duration.inMilliseconds,
    );
  } catch (_) {
    _localVideoAspectRatioCache[file.path] = fallbackAspectRatio;
    return LocalVideoMetadata(
      aspectRatio: fallbackAspectRatio,
      durationMs: 0,
    );
  } finally {
    await controller.dispose();
  }
}

void clearLocalVideoAspectRatioCache([String? path]) {
  if (path == null) {
    _localVideoAspectRatioCache.clear();
    return;
  }
  _localVideoAspectRatioCache.remove(path);
}
