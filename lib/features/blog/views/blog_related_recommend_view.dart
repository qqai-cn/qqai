import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/format_count.dart';
import 'package:qqai/util/media_url.dart';

import '../data/blog_list_patch.dart';
import '../data/models/blog_page_model.dart';
import '../data/repos/blog_repo.dart';

/// 详情侧栏「相关推荐」：同类型博客列表（排除当前篇）。
class BlogRelatedRecommendView extends ConsumerStatefulWidget {
  final BlogItem currentBlog;

  const BlogRelatedRecommendView({super.key, required this.currentBlog});

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
    } else {
      context.push(Routes.blogVideoDetailView, extra: item);
    }
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
      return Center(
        child: Text('暂无相关推荐', style: context.typo.body),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _items[index];
          return _RecommendTile(item: item, onTap: () => _openBlog(item));
        },
      ),
    );
  }
}

class _RecommendTile extends StatelessWidget {
  final BlogItem item;
  final VoidCallback onTap;

  const _RecommendTile({required this.item, required this.onTap});

  static const _thumbSize = 72.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
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
                  Text(
                    item.content ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.body,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.creatorName ?? '用户',
                    style: context.typo.caption.copyWith(
                      color: Colors.black54,
                    ),
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
