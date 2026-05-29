import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/blog/detail_avatar.dart';
import 'package:qqai/components/blog/detail_side_action_rail.dart';
import 'package:qqai/components/level_icon.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/providers/auth_providers.dart';
import 'package:qqai/util/format_count.dart';

import '../data/blog_detail_feed_resolver.dart';
import '../data/blog_display_text.dart';
import '../data/blog_feed_state_interactions.dart';
import '../data/blog_list_patch.dart';
import '../data/models/blog_page_model.dart';
import '../data/repos/blog_repo.dart';
import 'blog_avatar_preview.dart';

/// 详情侧栏操作数：只显示数字（无数量时显示 0）。
String blogDetailCountLabel(int? count) {
  final n = count ?? 0;
  if (n <= 0) return '0';
  return formatCompactCount(n);
}

/// 详情左下角：作者头像、昵称、粉丝、正文。
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
    final auth = ref.watch(authProvider);
    final avatarUrl = blogCreatorAvatarUrl(item, currentUserId: auth.userId);
    final name = item.creatorName?.trim();
    final displayName = (name != null && name.isNotEmpty) ? name : '用户';
    final fullText = blogVideoDetailFullText(item);

    return Positioned(
      left: 12,
      right: 100,
      bottom: bottomInset,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (avatarUrl != null) ...[
            InkWell(
              onTap: () => openBlogAvatarPreview(
                context,
                blog: item,
                heroTag: blogAvatarDetailHeroTag(item),
                imageUrl: avatarUrl,
              ),
              child: buildDetailAvatar(
                avatarUrl: avatarUrl,
                size: 44,
                context: context,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '@$displayName',
                        style: context.typo.bodyStrong.copyWith(
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (blogCreatorLevel(item) > 0) ...[
                      const SizedBox(width: 6),
                      LevelIcon(lv: blogCreatorLevel(item)),
                    ],
                  ],
                ),
                if (fullText.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => _showFullContent(context, fullText),
                    child: buildBlogVideoDetailText(
                      item: item,
                      titleStyle: context.typo.bodyStrong.copyWith(
                        color: Colors.white,
                      ),
                      bodyStyle: context.typo.body.copyWith(
                        color: Colors.white,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ],
            ),
          ),
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

class _BlogDetailMediaOverlayState extends ConsumerState<BlogDetailMediaOverlay> {
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
          onCommentTap: widget.onCommentTap,
        ),
      ],
    );
  }
}
