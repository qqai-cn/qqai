import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/components/blog/video_cover_fit.dart';
import 'package:qqai/components/video_player/qqai_player.dart';
import 'package:qqai/features/blog/data/blog_display_text.dart';
import 'package:qqai/features/blog/data/blog_route_extra.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/blog/views/blog_detail_ui.dart';
import 'package:qqai/features/comment/providers/comment_providers.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/media_url.dart';
import 'package:qqai/util/visibility_safe.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 与影视网格 [SliverGrid] 的 [childAspectRatio] 计算保持一致。
/// 影视列表列数临界（逻辑宽 > 此值 3 列，否则 2 列）。
const double kFilmListWideBreakpoint = 1000;
/// 影视网格封面比例临界（逻辑宽 > 此值横版 3:2，否则竖版 2:3）。
const double kFilmGridThumbWideBreakpoint = 800;

const double kFilmGridTextBlockHeight = 54;
const double kFilmGridThumbTextGap = 8;
const int _filmHeroCategory = -1001;

/// 宽屏网格封面：横版 3:2；窄屏：竖版 2:3。
const double kFilmGridThumbAspectWide = 3 / 2;
const double kFilmGridThumbAspectNarrow = 2 / 3;

double filmGridThumbAspectRatio({required bool isWideScreen}) =>
    isWideScreen ? kFilmGridThumbAspectWide : kFilmGridThumbAspectNarrow;

double filmGridChildAspectRatio(
  double cellWidth, {
  required bool isWideScreen,
}) {
  final thumbH = cellWidth / filmGridThumbAspectRatio(isWideScreen: isWideScreen);
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
/// Web：鼠标在封面停留约 3 秒后静音预览视频。
class VideoItemView extends ConsumerStatefulWidget {
  const VideoItemView({
    super.key,
    required this.item,
    required this.defaultCover,
    this.isWideScreen,
  });

  final BlogItem item;
  final String defaultCover;

  /// 为 null 时按 [ScreenUtil] 宽度是否大于 [kFilmGridThumbWideBreakpoint] 判断封面比例。
  final bool? isWideScreen;

  @override
  ConsumerState<VideoItemView> createState() => _VideoItemViewState();
}

class _VideoItemViewState extends ConsumerState<VideoItemView> {
  static const Color _cardBg = Color(0xFF14141C);
  static const Color _titleColor = Color(0xFFF2F2F5);
  static const Color _footerColor = Color(0xFF9A9AA8);

  Timer? _hoverTimer;
  bool _hovering = false;
  bool _showPreview = false;

  BlogItem get item => widget.item;

  String get _description {
    final preview = blogVideoListPreview(item).trim();
    if (preview.isNotEmpty) return preview;
    for (final collection in _namedCollections) {
      final name = collection.name?.trim();
      if (name != null && name.isNotEmpty) return name;
    }
    return '未命名';
  }

  @override
  void dispose() {
    _hoverTimer?.cancel();
    super.dispose();
  }

  void _onHoverEnter() {
    if (!kIsWeb) return;
    _hovering = true;
    _hoverTimer?.cancel();
    _hoverTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted || !_hovering) return;
      unawaited(_startPreview());
    });
  }

  void _onHoverExit() {
    _hovering = false;
    _hoverTimer?.cancel();
    _hoverTimer = null;
    _stopPreview();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    final fraction = safeVisibleFraction(info);
    if (fraction < 0.05) {
      _onHoverExit();
    }
  }

  void _stopPreview() {
    if (mounted && _showPreview) {
      setState(() => _showPreview = false);
    } else {
      _showPreview = false;
    }
  }

  @override
  void didUpdateWidget(VideoItemView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) {
      _onHoverExit();
    }
  }

  Future<void> _startPreview() async {
    if (firstPlayableVideoUrlFromResources(item.resources) == null ||
        !mounted ||
        !_hovering) {
      return;
    }
    setState(() => _showPreview = true);
  }

  List<BlogItemCollection> get _namedCollections {
    return (item.collections ?? [])
        .where((e) => e.name?.trim().isNotEmpty == true)
        .toList();
  }

  void _openDetail({BlogItemCollection? openCollection}) {
    final mediaHeroTag = blogVideoDetailHeroTag(_filmHeroCategory, item);
    if (openCollection != null) {
      ref.read(commentProvider.notifier).openCollectionPanel(openCollection);
    }
    context.push(
      Routes.videoDetailView,
      extra: blogDetailRouteExtra(item, mediaHeroTag: mediaHeroTag),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen =
        widget.isWideScreen ?? 1.sw > kFilmGridThumbWideBreakpoint;
    final thumbAspect = filmGridThumbAspectRatio(isWideScreen: isWideScreen);
    final cover = resolveBlogCoverUrl(item, fallback: widget.defaultCover);
    final videoUrl = resolveMediaUrl(
      firstPlayableVideoUrlFromResources(item.resources),
    );
    final mediaHeroTag = blogVideoDetailHeroTag(_filmHeroCategory, item);
    final collections = _namedCollections;
    final primaryCollection = collections.isEmpty ? null : collections.first;
    final name = item.creatorName?.trim().isNotEmpty == true
        ? item.creatorName!.trim()
        : '用户';
    final footer = '@$name · ${_formatFooterTime(item.updateTime)}';

    final thumb = Hero(
      tag: mediaHeroTag,
      transitionOnUserGestures: true,
      child: AspectRatio(
        aspectRatio: thumbAspect,
        child: MouseRegion(
          onEnter: (_) => _onHoverEnter(),
          onExit: (_) => _onHoverExit(),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: VideoCoverFit(
                    url: cover,
                    mode: VideoCoverFitMode.showFull,
                  ),
                ),
                if (_showPreview && _hovering && videoUrl != null)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: QqaiPlayer(
                        key: ValueKey('film_preview_${item.id}_$videoUrl'),
                        controls: const SizedBox.shrink(),
                        image: cover,
                        url: videoUrl,
                        autoPlay: true,
                        isActive: _hovering && _showPreview,
                        showLoadingPoster: true,
                        coverFitMode: VideoCoverFitMode.showFull,
                        videoFit: BoxFit.contain,
                        fallbackAspectRatio: thumbAspect,
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
                  right: 8,
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
                if (primaryCollection != null)
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: BlogCollectionChip(
                      collection: primaryCollection,
                      maxLabelWidth: 96,
                      onTap: () =>
                          _openDetail(openCollection: primaryCollection),
                    ),
                  ),
              ],
            ),
          ),
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
        child: InkWell(
          onTap: () => _openDetail(),
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
    );
  }
}
