import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/components/qq_network_image.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/visibility_safe.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 与影视网格 [SliverGrid] 的 [childAspectRatio] 计算保持一致。
const double kFilmGridTextBlockHeight = 54;
const double kFilmGridThumbTextGap = 8;

double filmGridChildAspectRatio(double cellWidth) {
  final thumbH = cellWidth * 2 / 3;
  return cellWidth /
      (thumbH + kFilmGridThumbTextGap + kFilmGridTextBlockHeight);
}

String _formatLikeCount(int? count) {
  final n = count ?? 0;
  if (n >= 10000) {
    final v = n / 10000;
    final s = (v == v.floorToDouble())
        ? v.toInt().toString()
        : v.toStringAsFixed(1);
    return '$s万';
  }
  return '$n';
}

String _formatFooterTime(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  final s = raw.trim();
  try {
    final d = DateTime.parse(s);
    return '${d.month}月${d.day}日';
  } catch (_) {
    if (s.length >= 10) return s.substring(0, 10).replaceAll('-', '/');
    return s;
  }
}

/// 影视 Tab 网格卡片：圆角封面 + 左下角点赞 + 双行标题 + `@作者 · 日期`。
///
/// Web：鼠标在卡片上停留约 2 秒后，在封面区域静音自动循环预览视频。
class VideoItemView extends StatefulWidget {
  const VideoItemView({
    super.key,
    required this.item,
    required this.defaultCover,
  });

  final BlogItem item;
  final String defaultCover;

  @override
  State<VideoItemView> createState() => _VideoItemViewState();
}

class _VideoItemViewState extends State<VideoItemView> {
  static const Color _cardBg = Color(0xFF14141C);
  static const Color _titleColor = Color(0xFFF2F2F5);
  static const Color _footerColor = Color(0xFF9A9AA8);

  Timer? _hoverTimer;
  bool _hovering = false;
  VideoPlayerController? _previewController;
  bool _showPreview = false;

  BlogItem get item => widget.item;

  String get _description {
    final c = item.content?.trim();
    if (c == null || c.isEmpty) return '未命名';
    return c;
  }

  @override
  void dispose() {
    _hoverTimer?.cancel();
    _previewController?.dispose();
    _previewController = null;
    super.dispose();
  }

  void _onHoverEnter() {
    if (!kIsWeb) return;
    _hovering = true;
    _hoverTimer?.cancel();
    _hoverTimer = Timer(const Duration(seconds: 1), () {
      if (!mounted || !_hovering) return;
      unawaited(_startPreview());
    });
  }

  void _onHoverExit() {
    if (!kIsWeb) return;
    _hovering = false;
    _hoverTimer?.cancel();
    _hoverTimer = null;
    _stopPreview();
  }

  void _stopPreview() {
    final c = _previewController;
    _previewController = null;
    c?.dispose();
    if (mounted && _showPreview) {
      setState(() => _showPreview = false);
    } else {
      _showPreview = false;
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (safeVisibleFraction(info) == 0) {
      _hovering = false;
      _hoverTimer?.cancel();
      _hoverTimer = null;
      _stopPreview();
    }
  }

  Future<void> _startPreview() async {
    final url = firstPlayableVideoUrlFromResources(item.resources);
    if (url == null || !mounted || !_hovering) return;

    final c = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await c.initialize();
    } catch (_) {
      await c.dispose();
      return;
    }
    if (!mounted || !_hovering) {
      await c.dispose();
      return;
    }
    _previewController = c;
    try {
      await c.setVolume(0);
      await c.setLooping(true);
      await c.play();
    } catch (_) {
      if (_previewController == c) {
        _previewController = null;
        await c.dispose();
      }
      return;
    }
    if (!mounted || !_hovering || _previewController != c) {
      if (_previewController == c) {
        _previewController = null;
        await c.dispose();
      }
      return;
    }
    setState(() => _showPreview = true);
  }

  @override
  Widget build(BuildContext context) {
    final cover = resolveBlogCoverUrl(item, fallback: widget.defaultCover);
    final name = item.creatorName?.trim().isNotEmpty == true
        ? item.creatorName!.trim()
        : '用户';
    final footer = '@$name · ${_formatFooterTime(item.updateTime)}';

    final thumb = AspectRatio(
      aspectRatio: 3 / 2,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final dpr = MediaQuery.devicePixelRatioOf(context);
                final cw = (constraints.maxWidth * dpr).round().clamp(120, 900);
                final ch = (constraints.maxHeight * dpr).round().clamp(80, 600);
                return QqNetworkImage(
                  url: cover,
                  fit: BoxFit.cover,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  cacheWidth: cw,
                  cacheHeight: ch,
                  placeholderColor: const Color(0xFF2A2A36),
                  errorIconColor: const Color(0xFF6B6B78),
                );
              },
            ),
            if (_showPreview &&
                _previewController != null &&
                _previewController!.value.isInitialized)
              Positioned.fill(
                child: IgnorePointer(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: _previewController!.value.size.width,
                      height: _previewController!.value.size.height,
                      child: VideoPlayer(_previewController!),
                    ),
                  ),
                ),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.72),
                    ],
                    stops: const [0.45, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: Row(
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 15,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    _formatLikeCount(item.zan),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      shadows: const [
                        Shadow(blurRadius: 6, color: Colors.black54),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return VisibilityDetector(
      key: Key('film_grid_video_${item.id ?? item.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Material(
        color: _cardBg,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: MouseRegion(
          onEnter: (_) => _onHoverEnter(),
          onExit: (_) => _onHoverExit(),
          child: InkWell(
            onTap: () => context.push(Routes.videoDetailView, extra: item),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                thumb,
                SizedBox(height: kFilmGridThumbTextGap),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: SizedBox(
                    height: kFilmGridTextBlockHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            _description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _titleColor,
                              fontSize: 13,
                              height: 1.35,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          footer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _footerColor,
                            fontSize: 11.5,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
