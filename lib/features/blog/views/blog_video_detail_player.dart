import 'package:flutter/material.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/components/video_player/detail_controls.dart';
import 'package:qqai/components/video_player/qqai_player.dart';
import 'package:qqai/util/media_url.dart';

import '../data/models/blog_page_model.dart';

/// 博客详情左侧：播放当前条目的真实视频（非 mock 列表）。
class BlogVideoDetailPlayer extends StatelessWidget {
  final BlogItem blog;

  const BlogVideoDetailPlayer({super.key, required this.blog});

  static const _defaultPoster =
      'https://file.qqai.cn/qqai/2025/09/1.webp';

  @override
  Widget build(BuildContext context) {
    final rawVideo = firstPlayableVideoUrlFromResources(blog.resources);
    final videoUrl = resolveMediaUrl(rawVideo);
    if (videoUrl == null || videoUrl.isEmpty) {
      return const Center(
        child: Text('暂无视频', style: TextStyle(color: Colors.white70)),
      );
    }
    final posterRaw = firstStillImageUrlFromResources(
      blog.resources,
      fallback: _defaultPoster,
    );
    final poster = resolveMediaUrl(posterRaw) ?? _defaultPoster;

    return SizedBox.expand(
      child: QqaiPlayer(
        controls: DetailControls(blog: blog),
        image: poster,
        url: videoUrl,
        autoPlay: true,
      ),
    );
  }
}
