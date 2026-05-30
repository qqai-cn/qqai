import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qqai/components/blog/video_thumbnail.dart';
import 'package:qqai/components/video_player/video_aspect_ratio.dart';
import 'package:qqai/features/blog/views/video_item_player/video_item_player.dart';
import 'package:qqai/util/media_url.dart';
import 'package:qqai/util/visibility_safe.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 仅当可见时挂载播放器，否则封面，减轻列表滑动压力。
class VisibilityVideoSlot extends StatefulWidget {
  final String url;
  final String imgUrl;
  final int? videoId;
  final double? aspectRatio;

  const VisibilityVideoSlot({
    super.key,
    required this.url,
    required this.imgUrl,
    this.videoId,
    this.aspectRatio,
  });

  @override
  State<VisibilityVideoSlot> createState() => _VisibilityVideoSlotState();
}

class _VisibilityVideoSlotState extends State<VisibilityVideoSlot> {
  static const double _visibleThreshold = 0.72;
  static const Duration _mountDelay = Duration(milliseconds: 450);

  Timer? _mountTimer;
  bool _shouldMountPlayer = false;

  @override
  void dispose() {
    _mountTimer?.cancel();
    super.dispose();
  }

  void _handleVisibility(VisibilityInfo info) {
    final active = safeVisibleFraction(info) >= _visibleThreshold;
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
      return hasResolvableMediaUrl(widget.url) && _shouldMountPlayer
          ? VideoItemPlayer(
              url: widget.url,
              imgUrl: widget.imgUrl,
              videoId: widget.videoId,
              fallbackAspectRatio: aspectRatio,
            )
          : VideoThumbnail(imgUrl: widget.imgUrl, aspectRatio: aspectRatio);
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
