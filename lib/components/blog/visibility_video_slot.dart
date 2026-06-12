import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qqai/components/blog/video_cover_fit.dart';
import 'package:qqai/components/video_player/video_aspect_ratio.dart';
import 'package:qqai/components/video_player/video_ad_overlay.dart';
import 'package:qqai/components/video_player/video_loading_placeholder.dart';
import 'package:qqai/features/blog/views/video_item_player/video_item_player.dart';
import 'package:qqai/util/media_url.dart';
import 'package:qqai/util/media_video_cache.dart';
import 'package:qqai/util/visibility_safe.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 仅当可见时挂载播放器，否则封面，减轻列表滑动压力。
class VisibilityVideoSlot extends StatefulWidget {
  final String url;
  final String imgUrl;
  final int? videoId;
  final double? aspectRatio;
  final String? playerHeroTag;
  final VideoAdPlaybackState? videoAdInitialState;
  final ValueChanged<VideoAdPlaybackState>? onVideoAdStateChanged;
  final VoidCallback? onCompleted;
  final bool autoPlay;
  final VideoCoverFitMode coverFitMode;

  const VisibilityVideoSlot({
    super.key,
    required this.url,
    required this.imgUrl,
    this.videoId,
    this.aspectRatio,
    this.playerHeroTag,
    this.videoAdInitialState,
    this.onVideoAdStateChanged,
    this.onCompleted,
    this.autoPlay = false,
    this.coverFitMode = VideoCoverFitMode.fill,
  });

  @override
  State<VisibilityVideoSlot> createState() => _VisibilityVideoSlotState();
}

class _VisibilityVideoSlotState extends State<VisibilityVideoSlot> {
  static const double _visibleThreshold = 0.72;
  static const double _precacheThreshold = 0.28;
  static const Duration _mountDelay = Duration(milliseconds: 450);

  Timer? _mountTimer;
  bool _shouldMountPlayer = false;

  @override
  void initState() {
    super.initState();
    _shouldMountPlayer = widget.autoPlay;
  }

  @override
  void didUpdateWidget(VisibilityVideoSlot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.autoPlay && widget.autoPlay && !_shouldMountPlayer) {
      _mountTimer?.cancel();
      _mountTimer = null;
      setState(() => _shouldMountPlayer = true);
    }
  }

  @override
  void dispose() {
    _mountTimer?.cancel();
    super.dispose();
  }

  void _handleVisibility(VisibilityInfo info) {
    final fraction = safeVisibleFraction(info);
    if (fraction >= _precacheThreshold) {
      precacheVideo(widget.url);
    }
    final active = fraction >= _visibleThreshold;
    if (active && !_shouldMountPlayer) {
      _mountTimer ??= Timer(_mountDelay, () {
        if (!mounted) return;
        setState(() {
          _shouldMountPlayer = true;
          _mountTimer = null;
        });
      });
      return;
    }
    if (!active) {
      _mountTimer?.cancel();
      _mountTimer = null;
      if (_shouldMountPlayer && mounted) {
        setState(() => _shouldMountPlayer = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildSlot(double aspectRatio) {
      Widget slotChild;
      if (hasResolvableMediaUrl(widget.url) && _shouldMountPlayer) {
        slotChild = VideoItemPlayer(
          url: widget.url,
          imgUrl: widget.imgUrl,
          videoId: widget.videoId,
          fallbackAspectRatio: aspectRatio,
          videoAdInitialState: widget.videoAdInitialState,
          onVideoAdStateChanged: widget.onVideoAdStateChanged,
          onCompleted: widget.onCompleted,
          autoPlay: widget.autoPlay,
          coverFitMode: widget.coverFitMode,
        );
      } else {
        slotChild = VideoLoadingPlaceholder(
          imageUrl: widget.imgUrl,
          showPoster: true,
          coverFitMode: widget.coverFitMode,
        );
      }

      final slot = AspectRatio(aspectRatio: aspectRatio, child: slotChild);
      final heroTag = widget.playerHeroTag;
      if (heroTag == null || heroTag.isEmpty) return slot;

      return Hero(tag: heroTag, transitionOnUserGestures: true, child: slot);
    }

    return VisibilityDetector(
      key: Key('lazy_video_${widget.url.hashCode}'),
      onVisibilityChanged: _handleVisibility,
      child: widget.aspectRatio != null
          ? buildSlot(widget.aspectRatio!)
          : VideoAspectRatioBox(
              videoUrl: widget.url,
              builder: (context, aspectRatio) => buildSlot(aspectRatio),
            ),
    );
  }
}
