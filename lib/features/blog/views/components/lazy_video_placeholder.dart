import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qqai/features/blog/views/video_item_player/video_item_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 仅当可见时加载视频播放器，否则只显示封面，减轻列表滑动卡顿。
class LazyVideoPlaceholder extends StatefulWidget {
  final String url;
  final String imgUrl;

  const LazyVideoPlaceholder({
    super.key,
    required this.url,
    required this.imgUrl,
  });

  @override
  State<LazyVideoPlaceholder> createState() => _LazyVideoPlaceholderState();
}

class _LazyVideoPlaceholderState extends State<LazyVideoPlaceholder> {
  double _visibleFraction = 0;
  static const double _visibleThreshold = 0.25;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('lazy_video_${widget.url.hashCode}'),
      onVisibilityChanged: (info) {
        if (mounted && info.visibleFraction != _visibleFraction) {
          setState(() => _visibleFraction = info.visibleFraction);
        }
      },
      child: _visibleFraction >= _visibleThreshold
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
        CachedNetworkImage(imageUrl: imgUrl, fit: BoxFit.cover),
        const Icon(Icons.play_circle_fill, size: 56, color: Colors.white70),
      ],
    );
  }
}
