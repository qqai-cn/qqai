import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/blog/blog_danmaku.dart';
import 'package:qqai/components/blog/detail_side_action_rail.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/providers/auth_providers.dart';
import 'package:qqai/util/conversation_list_time_format.dart';
import 'package:qqai/util/format_count.dart';

import '../data/blog_detail_feed_resolver.dart';
import '../data/blog_display_text.dart';
import '../data/blog_feed_state_interactions.dart';
import '../data/blog_list_patch.dart';
import '../data/models/blog_page_model.dart';
import '../data/repos/blog_repo.dart';
import '../../comment/providers/comment_providers.dart';
import 'blog_avatar_preview.dart';
import 'blog_shop_product_display.dart';

/// 详情侧栏操作数：只显示数字（无数量时显示 0）。
String blogDetailCountLabel(int? count) {
  final n = count ?? 0;
  if (n <= 0) return '0';
  return formatCompactCount(n);
}

/// 详情左下角：作者与时间、正文、合集按钮。
class BlogDetailBottomInfo extends ConsumerWidget {
  final BlogItem blog;
  final double bottomInset;

  const BlogDetailBottomInfo({
    super.key,
    required this.blog,
    this.bottomInset = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = resolveBlogItem(ref, blog);
    final name = item.creatorName?.trim();
    final displayName = (name != null && name.isNotEmpty) ? name : '用户';
    final fullText = blogVideoDetailFullText(item);
    final time = formatConversationListTime(item.createTime);
    final collections = (item.collections ?? [])
        .where((e) => e.name?.trim().isNotEmpty == true)
        .toList();
    final shopProducts = visibleBlogShopProducts(item);
    final showDanmakuLaunch =
        MediaQuery.sizeOf(context).width <= 900 &&
        item.blogType == 2 &&
        item.id != null;

    return Positioned(
      left: 12,
      right: 100,
      bottom: bottomInset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDanmakuLaunch) ...[
            BlogDanmakuLaunchBar(blogId: item.id),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              Flexible(
                child: Text(
                  '@$displayName',
                  style: context.typo.bodyStrong.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    shadows: const [
                      Shadow(color: Colors.black54, blurRadius: 4),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (time.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  time,
                  style: context.typo.body.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    shadows: const [
                      Shadow(color: Colors.black54, blurRadius: 4),
                    ],
                  ),
                ),
              ],
            ],
          ),
          if (fullText.isNotEmpty) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showFullContent(context, fullText),
              child: buildBlogVideoDetailText(
                item: item,
                bodyStyle: context.typo.body.copyWith(
                  color: Colors.white,
                  fontSize: 17,
                  height: 1.35,
                  shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                ),
                maxLines: 3,
              ),
            ),
          ],
          if (collections.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final collection in collections)
                  BlogCollectionChip(
                    collection: collection,
                    onTap: () => _openCollectionPanel(ref, collection),
                  ),
              ],
            ),
          ],
          if (shopProducts.isNotEmpty) ...[
            const SizedBox(height: 12),
            BlogShopProductStrip(products: shopProducts.take(3).toList()),
          ],
        ],
      ),
    );
  }

  void _showFullContent(BuildContext context, String text) {
    showModalBottomSheet<void>(
      context: context,
      constraints: BoxConstraints(maxHeight: 0.5.sh),
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(child: Text(text)),
      ),
    );
  }

  void _openCollectionPanel(WidgetRef ref, BlogItemCollection collection) {
    ref.read(commentProvider.notifier).openCollectionPanel(collection);
  }
}

/// 详情 / 列表共用的「合集 · xxx」胶囊按钮。
class BlogCollectionChip extends StatelessWidget {
  final BlogItemCollection collection;
  final VoidCallback onTap;
  final double? maxLabelWidth;

  const BlogCollectionChip({
    super.key,
    required this.collection,
    required this.onTap,
    this.maxLabelWidth = 180,
  });

  @override
  Widget build(BuildContext context) {
    final name = collection.name?.trim();
    return Material(
      color: Colors.white.withValues(alpha: 0.26),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.collections_bookmark_outlined,
                color: Colors.white,
                size: 14,
              ),
              const SizedBox(width: 4),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxLabelWidth ?? 180),
                child: Text(
                  '合集 · ${name?.isNotEmpty == true ? name! : '合集'}',
                  style: context.typo.bodyStrong.copyWith(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 博客详情：右侧操作条 + 可选左下角文案（图文/视频共用）。
///
/// 五角星按钮为收藏；已收藏时高亮为琥珀色实心星。
class BlogDetailMediaOverlay extends ConsumerStatefulWidget {
  final BlogItem blog;
  final VoidCallback onCommentTap;
  final double bottomInset;

  const BlogDetailMediaOverlay({
    super.key,
    required this.blog,
    required this.onCommentTap,
    this.bottomInset = 0,
  });

  @override
  ConsumerState<BlogDetailMediaOverlay> createState() =>
      _BlogDetailMediaOverlayState();
}

class _BlogDetailMediaOverlayState
    extends ConsumerState<BlogDetailMediaOverlay> {
  BlogItem? _standaloneItem;

  BlogItem _currentItem(WidgetRef ref) {
    final resolved = resolveBlogItem(ref, widget.blog);
    return _standaloneItem ?? resolved;
  }

  Future<void> _onCollectTap(BlogItem item) async {
    if (blogItemExistsInKnownFeeds(ref, item)) {
      resolveBlogFeedActions(ref, item).onCollectTap(item);
      return;
    }

    final r = await toggleCollectStandalone(ref.read(blogRepoProvider), item);
    if (!mounted) return;
    if (r.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(r.error!)));
      return;
    }
    if (r.item != null) {
      setState(() => _standaloneItem = r.item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = _currentItem(ref);
    final auth = ref.watch(authProvider);
    final avatarUrl = blogCreatorAvatarUrl(item, currentUserId: auth.userId);
    final actions = resolveBlogFeedActions(ref, item);
    final showFollow = shouldShowBlogFollowButton(item, auth.userId);
    final following = blogFollowCare(item) == 1;
    final avatarHeroTag = avatarUrl != null
        ? blogAvatarDetailHeroTag(item)
        : null;

    return Stack(
      children: [
        BlogDetailBottomInfo(blog: item, bottomInset: widget.bottomInset),
        DetailSideActionRail(
          bottomOffset: widget.bottomInset,
          avatarUrl: avatarUrl,
          avatarHeroTag: avatarHeroTag,
          onAvatarTap: avatarUrl != null && avatarHeroTag != null
              ? () => openBlogAvatarPreview(
                  context,
                  blog: item,
                  heroTag: avatarHeroTag,
                  imageUrl: avatarUrl,
                )
              : null,
          showFollowButton: showFollow,
          isFollowing: following,
          liked: blogLikedByMe(item),
          collected: blogCollectedByMe(item),
          likeCountLabel: blogDetailCountLabel(item.zan),
          commentCountLabel: blogDetailCountLabel(item.commentCount),
          collectCountLabel: blogDetailCountLabel(item.collectCount),
          shareCountLabel: blogDetailCountLabel(item.shareCount),
          shareBlog: item,
          onLikeTap: () => actions.onZanTap(item),
          onFollowTap: () => actions.onCareTap(item),
          onCollectTap: () => unawaited(_onCollectTap(item)),
          onShareTap: () => actions.onShareTap(item),
          onBlogDeleted: (_) {
            if (context.canPop()) {
              context.pop();
            }
          },
          onCommentTap: widget.onCommentTap,
        ),
      ],
    );
  }
}
