import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qqai/components/blog/video_cover_fit.dart';
import 'package:qqai/features/blog/views/video_item_player/video_item_player.dart';
import 'package:qqai/util/media_url.dart';
import 'package:qqai/util/visibility_safe.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 仅当可见时挂载播放器，否则封面，减轻列表滑动压力。
class VisibilityVideoSlot extends StatefulWidget {
  final String url;
  final String imgUrl;

  const VisibilityVideoSlot({
    super.key,
    required this.url,
    required this.imgUrl,
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
    return VisibilityDetector(
      key: Key('lazy_video_${widget.url.hashCode}'),
      onVisibilityChanged: _handleVisibility,
      child: hasResolvableMediaUrl(widget.url) && _shouldMountPlayer
          ? VideoItemPlayer(url: widget.url, imgUrl: widget.imgUrl)
          : _VideoThumbnail(imgUrl: widget.imgUrl),
    );
  }
}

class _VideoThumbnail extends StatelessWidget {
  final String imgUrl;

  const _VideoThumbnail({required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        VideoCoverFit(url: imgUrl),
        const Icon(Icons.play_circle_fill, size: 56, color: Colors.white70),
      ],
    );
  }
}
