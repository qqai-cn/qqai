import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'feed_video_manager.dart';

/// Feed 流视频播放组件
/// [manager] 为空时为独立模式（单视频）；有值时与 feed 共享管理
class FeedVideoPlayer extends StatefulWidget {
  const FeedVideoPlayer({
    super.key,
    required this.url,
    this.thumbnailUrl,
    this.manager,
  });

  final String url;
  final String? thumbnailUrl;
  final FeedVideoManager? manager;

  @override
  State<FeedVideoPlayer> createState() => _FeedVideoPlayerState();
}

class _FeedVideoPlayerState extends State<FeedVideoPlayer> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _initialized = false;
  bool _registered = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    if (widget.url.isEmpty) return;
    final ctrl = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..setLooping(true);
    _controller = ctrl;

    final chewie = ChewieController(
      videoPlayerController: ctrl,
      autoInitialize: true,
      autoPlay: false,
      looping: true,
      aspectRatio: null,
      placeholder: _buildPlaceholder(),
      errorBuilder: (_, err) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(err, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
    _chewieController = chewie;

    ctrl.addListener(_onStateChanged);
    if (ctrl.value.isInitialized) {
      _onInitialized();
    }
  }

  void _onStateChanged() {
    if (!mounted || _registered) return;
    if (_controller?.value.isInitialized == true) {
      _onInitialized();
    }
  }

  void _onInitialized() {
    _controller?.removeListener(_onStateChanged);
    _initialized = true;
    if (widget.manager != null) {
      widget.manager!.register(_controller!);
      _registered = true;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.removeListener(_onStateChanged);
    if (_registered && widget.manager != null) {
      widget.manager!.unregister(_controller!);
    }
    _chewieController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(double visibleFraction) {
    if (!mounted || !_initialized || _controller == null) return;
    if (visibleFraction > 0.8) {
      if (widget.manager != null) {
        widget.manager!.play(_controller!);
      } else {
        _controller!.setVolume(0);
        _controller!.play();
      }
    } else if (visibleFraction < 0.3) {
      if (widget.manager != null) {
        widget.manager!.pauseIf(_controller!);
      } else {
        _controller!.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1, minHeight: 1),
        child: Container(color: Colors.black, child: _buildPlaceholder()),
      );
    }

    return VisibilityDetector(
      key: Key('feed_video_${widget.url}'),
      onVisibilityChanged: (info) => _onVisibilityChanged(info.visibleFraction),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1, minHeight: 1),
        child: LayoutBuilder(
          builder: (_, constraints) {
            final ar = _controller?.value.aspectRatio ?? 16 / 9;
            return ClipRect(
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Chewie(controller: _chewieController!),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.thumbnailUrl != null)
          Image.network(widget.thumbnailUrl!, fit: BoxFit.cover)
        else
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
