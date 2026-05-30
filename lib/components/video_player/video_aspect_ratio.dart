import 'package:flutter/material.dart';
import 'package:qqai/util/media_url.dart';
import 'package:video_player/video_player.dart';

typedef VideoAspectRatioBuilder =
    Widget Function(BuildContext context, double aspectRatio);

double effectiveVideoAspectRatio(VideoPlayerValue value, double fallback) {
  final aspectRatio = value.aspectRatio;
  if (value.isInitialized &&
      aspectRatio.isFinite &&
      !aspectRatio.isNaN &&
      aspectRatio > 0) {
    return aspectRatio;
  }
  return fallback;
}

class VideoAspectRatioBox extends StatefulWidget {
  const VideoAspectRatioBox({
    super.key,
    required this.videoUrl,
    required this.builder,
    this.fallbackAspectRatio = 15 / 9,
  });

  final String videoUrl;
  final VideoAspectRatioBuilder builder;
  final double fallbackAspectRatio;

  @override
  State<VideoAspectRatioBox> createState() => _VideoAspectRatioBoxState();
}

class _VideoAspectRatioBoxState extends State<VideoAspectRatioBox> {
  static final Map<String, double> _aspectRatioCache = {};

  double? _aspectRatio;
  int _loadVersion = 0;

  @override
  void initState() {
    super.initState();
    _loadAspectRatio();
  }

  @override
  void didUpdateWidget(VideoAspectRatioBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl ||
        oldWidget.fallbackAspectRatio != widget.fallbackAspectRatio) {
      _aspectRatio = null;
      _loadAspectRatio();
    }
  }

  Future<void> _loadAspectRatio() async {
    final version = ++_loadVersion;
    final url = resolveMediaUrl(widget.videoUrl);
    if (url == null) return;

    final cachedAspectRatio = _aspectRatioCache[url];
    if (cachedAspectRatio != null) {
      _aspectRatio = cachedAspectRatio;
      return;
    }

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await controller.initialize();
      if (!mounted || version != _loadVersion) return;
      final aspectRatio = effectiveVideoAspectRatio(
        controller.value,
        widget.fallbackAspectRatio,
      );
      _aspectRatioCache[url] = aspectRatio;
      setState(() {
        _aspectRatio = aspectRatio;
      });
    } catch (_) {
      // Keep the fallback ratio if metadata cannot be loaded.
    } finally {
      await controller.dispose();
    }
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
