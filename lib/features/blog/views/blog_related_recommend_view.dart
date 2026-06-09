import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/format_count.dart';
import 'package:qqai/util/media_url.dart';

import '../data/blog_display_text.dart';
import '../data/blog_list_patch.dart';
import '../data/models/blog_page_model.dart';
import '../data/repos/blog_repo.dart';
import '../../comment/providers/comment_providers.dart';
import '../../my/data/repos/profile_repo.dart';

/// 详情侧栏「相关推荐」：同类型博客列表（排除当前篇）。
class BlogRelatedRecommendView extends ConsumerStatefulWidget {
  final BlogItem currentBlog;
  final String detailRoute;

  const BlogRelatedRecommendView({
    super.key,
    required this.currentBlog,
    this.detailRoute = Routes.blogVideoDetailView,
  });

  @override
  ConsumerState<BlogRelatedRecommendView> createState() =>
      _BlogRelatedRecommendViewState();
}

class _BlogRelatedRecommendViewState
    extends ConsumerState<BlogRelatedRecommendView> {
  List<BlogItem> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(blogRepoProvider);
      final page = await repo.getBlogPageModelDataWithPage(
        1,
        pageSize: 20,
        blogType: widget.currentBlog.blogType,
        categary: widget.currentBlog.categary,
      );
      final id = widget.currentBlog.id;
      final list = (page.list ?? [])
          .where((b) => b.id != null && b.id != id)
          .toList();
      if (!mounted) return;
      setState(() {
        _items = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  void _openBlog(BlogItem item) {
    if (item.blogType == 1) {
      context.push(Routes.blogImgDetailView, extra: item);
      return;
    }
    context.pushReplacement(widget.detailRoute, extra: item);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_error!, textAlign: TextAlign.center),
            ),
            TextButton(onPressed: _load, child: const Text('重试')),
          ],
        ),
      );
    }
    if (_items.isEmpty) {
      return Center(child: Text('暂无相关推荐', style: context.typo.body));
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _items.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: AppActionColors.borderSubtle(context),
        ),
        itemBuilder: (context, index) {
          final item = _items[index];
          return _RecommendTile(item: item, onTap: () => _openBlog(item));
        },
      ),
    );
  }
}

/// 详情侧栏「合集」：展示当前合集内的视频列表。
class BlogCollectionVideosView extends ConsumerStatefulWidget {
  final BlogItem currentBlog;
  final BlogItemCollection? collection;
  final String detailRoute;

  const BlogCollectionVideosView({
    super.key,
    required this.currentBlog,
    required this.collection,
    this.detailRoute = Routes.blogVideoDetailView,
  });

  @override
  ConsumerState<BlogCollectionVideosView> createState() =>
      _BlogCollectionVideosViewState();
}

class _BlogCollectionVideosViewState
    extends ConsumerState<BlogCollectionVideosView> {
  List<BlogItem> _items = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(BlogCollectionVideosView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collection?.id != widget.collection?.id) {
      _load();
    }
  }

  Future<void> _load() async {
    final collectionId = widget.collection?.id;
    if (collectionId == null) {
      setState(() {
        _items = [];
        _loading = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final detail = await ref
          .read(profileRepoProvider)
          .getCollectionDetail(collectionId);
      final videos = (detail.blogs ?? [])
          .where(
            (b) =>
                b.id != null &&
                b.blogType == widget.currentBlog.blogType,
          )
          .toList();
      if (!mounted) return;
      setState(() {
        _items = videos;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  void _openBlog(BlogItem item) {
    final collection = widget.collection;
    if (collection != null) {
      ref.read(commentProvider.notifier).openCollectionPanel(collection);
    }
    final extra = item.copyWith(
      collections: collection == null ? item.collections : [collection],
    );
    if (item.blogType == 1) {
      context.pushReplacement(Routes.blogImgDetailView, extra: extra);
      return;
    }
    context.pushReplacement(widget.detailRoute, extra: extra);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.collection == null) {
      return Center(child: Text('请选择合集', style: context.typo.body));
    }
    if (widget.collection?.id == null) {
      return Center(child: Text('合集信息缺少编号', style: context.typo.body));
    }
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_error!, textAlign: TextAlign.center),
            ),
            TextButton(onPressed: _load, child: const Text('重试')),
          ],
        ),
      );
    }
    if (_items.isEmpty) {
      return Center(child: Text('暂无合集视频', style: context.typo.body));
    }

    final name = widget.collection?.name?.trim();
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _items.length + (name?.isNotEmpty == true ? 1 : 0),
        separatorBuilder: (_, index) => index == 0 && name?.isNotEmpty == true
            ? const SizedBox.shrink()
            : Divider(
                height: 1,
                color: AppActionColors.borderSubtle(context),
              ),
        itemBuilder: (context, index) {
          if (name?.isNotEmpty == true && index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
              child: Text(
                name!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typo.bodyStrong,
              ),
            );
          }
          final itemIndex = name?.isNotEmpty == true ? index - 1 : index;
          final item = _items[itemIndex];
          return _RecommendTile(
            item: item,
            selected: item.id != null && item.id == widget.currentBlog.id,
            onTap: () => _openBlog(item),
          );
        },
      ),
    );
  }
}

class _RecommendTile extends StatelessWidget {
  final BlogItem item;
  final VoidCallback onTap;
  final bool selected;

  const _RecommendTile({
    required this.item,
    required this.onTap,
    this.selected = false,
  });

  static const _thumbSize = 72.0;

  @override
  Widget build(BuildContext context) {
    final title = blogVideoSidePanelTitle(item);
    final content = blogVideoSidePanelContent(item);
    final selectedColor = Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFE65100)
        : Colors.orange.shade300;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: selected
            ? (Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFFFF3E0)
                : Colors.orange.withValues(alpha: 0.15))
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RecommendThumb(item: item),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selected) ...[
                    Text(
                      '正在播放',
                      style: context.typo.caption.copyWith(
                        color: selectedColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (title != null)
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.typo.bodyStrong.copyWith(
                        color: selected ? selectedColor : null,
                      ),
                    ),
                  if (content != null) ...[
                    if (title != null) const SizedBox(height: 4),
                    Text(
                      content,
                      maxLines: title != null ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.typo.body.copyWith(
                        color: selected
                            ? selectedColor
                            : AppActionColors.muted(context),
                      ),
                    ),
                  ],
                  if (title == null && content == null)
                    Text(
                      '未命名',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.typo.body.copyWith(
                        color: AppActionColors.muted(context),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    item.creatorName ?? '用户',
                    style: context.typo.caption.copyWith(color: AppActionColors.muted(context)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${formatCompactCount(item.zan)}赞 · ${formatCompactCount(item.commentCount)}评',
                    style: context.typo.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 相关推荐缩略图：图文取首图，视频取封面；无则头像，再无则默认图。
class _RecommendThumb extends StatelessWidget {
  final BlogItem item;

  const _RecommendThumb({required this.item});

  static const _size = _RecommendTile._thumbSize;

  @override
  Widget build(BuildContext context) {
    final thumbUrl = _primaryThumbUrl(item);
    final avatarUrl = blogCreatorAvatarUrl(item);

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: _size,
        height: _size,
        child: thumbUrl != null
            ? _networkImage(
                thumbUrl,
                error: avatarUrl != null
                    ? _networkImage(avatarUrl, error: _defaultThumb())
                    : _defaultThumb(),
              )
            : avatarUrl != null
            ? _networkImage(avatarUrl, error: _defaultThumb())
            : _defaultThumb(),
      ),
    );
  }

  /// 图文：resources 首图；视频：coverUrl，其次 resources 内静图。
  static String? _primaryThumbUrl(BlogItem item) {
    if (item.blogType == 1) {
      final image = firstStillImageUrlFromResources(item.resources);
      if (image != null) return resolveMediaUrl(image);
      final urls = parseCommaSeparatedUrls(item.resources);
      if (urls.isNotEmpty) return resolveMediaUrl(urls.first);
      return null;
    }

    final cover = item.coverUrl?.trim();
    if (cover != null && cover.isNotEmpty) {
      return resolveMediaUrl(cover);
    }
    final still = firstStillImageUrlFromResources(item.resources);
    return resolveMediaUrl(still);
  }

  static Widget _networkImage(String url, {required Widget error}) {
    return CachedNetworkImage(
      imageUrl: url,
      width: _size,
      height: _size,
      fit: BoxFit.cover,
      placeholder: (_, _) => _defaultThumb(),
      errorWidget: (_, _, _) => error,
    );
  }

  static Widget _defaultThumb() {
    return Image.asset(
      'imgs/img_default.png',
      width: _size,
      height: _size,
      fit: BoxFit.cover,
    );
  }
}
