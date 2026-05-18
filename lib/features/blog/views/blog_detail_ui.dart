import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/blog/detail_avatar.dart';
import 'package:qqai/components/blog/detail_side_action_rail.dart';
import 'package:qqai/components/level_icon.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/providers/auth_providers.dart';
import 'package:qqai/util/format_count.dart';
import '../../index/providers/home_follow_feed_providers.dart';
import '../data/blog_list_patch.dart';
import '../data/models/blog_page_model.dart';
import '../data/home_blog_tab.dart';
import '../providers/blog_providers.dart';
import 'blog_avatar_preview.dart';

/// 详情侧栏操作数：只显示数字（无数量时显示 0）。
String blogDetailCountLabel(int? count) {
  final n = count ?? 0;
  if (n <= 0) return '0';
  return formatCompactCount(n);
}

BlogItem _resolveFromState(BlogState state, BlogItem initial) {
  final id = initial.id;
  if (id == null) return initial;
  for (final b in state.allItems) {
    if (b.id == id) return b;
  }
  final pageList = switch (state.blogPageData) {
    AsyncData(:final value) => value.list,
    _ => null,
  };
  if (pageList != null) {
    for (final b in pageList) {
      if (b.id == id) return b;
    }
  }
  return initial;
}

/// 从详情上下文 feed 状态中取最新条目（推荐 / 热点 / 本地 / 关注）。
BlogItem resolveBlogItem(WidgetRef ref, BlogItem initial) {
  final id = initial.id;
  if (id == null) return initial;

  final states = [
    ref.watch(homeFollowFeedProvider),
    ref.watch(blogProvider(HomeBlogTab.recommend)),
    ref.watch(blogProvider(HomeBlogTab.hot)),
    ref.watch(blogProvider(HomeBlogTab.local)),
  ];
  for (final state in states) {
    for (final b in state.allItems) {
      if (b.id == id) return b;
    }
    final pageList = switch (state.blogPageData) {
      AsyncData(:final value) => value.list,
      _ => null,
    };
    if (pageList != null) {
      for (final b in pageList) {
        if (b.id == id) return b;
      }
    }
  }
  return initial;
}

/// 从推荐/关注流列表取最新条目（点赞、分享后同步按钮文案）。
BlogItem resolveFeedBlogItem(
  WidgetRef ref,
  BlogItem initial, {
  required bool followFeed,
  int feedCategory = HomeBlogTab.recommend,
}) {
  final state = followFeed
      ? ref.watch(homeFollowFeedProvider)
      : ref.watch(blogProvider(feedCategory));
  return _resolveFromState(state, initial);
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
    final avatarHeroTag = avatarUrl != null
        ? blogAvatarDetailHeroTag(item)
        : null;
    final name = item.creatorName?.trim();
    final displayName = (name != null && name.isNotEmpty) ? name : '用户';
    final content = item.content?.trim() ?? '';

    return Positioned(
      left: 12,
      right: 100,
      bottom: bottomInset,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (avatarUrl != null) ...[
            InkWell(
              onTap: avatarHeroTag != null
                  ? () => openBlogAvatarPreview(
                      context,
                      blog: item,
                      heroTag: avatarHeroTag,
                      imageUrl: avatarUrl,
                    )
                  : null,
              child: avatarHeroTag != null
                  ? Hero(
                      tag: avatarHeroTag,
                      child: buildDetailAvatar(
                        avatarUrl: avatarUrl,
                        size: 44,
                        context: context,
                      ),
                    )
                  : buildDetailAvatar(
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
                if (content.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => _showFullContent(context, content),
                    child: Text(
                      content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.typo.body.copyWith(color: Colors.white),
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
class BlogDetailMediaOverlay extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final item = resolveBlogItem(ref, blog);
    final auth = ref.watch(authProvider);
    final avatarUrl = blogCreatorAvatarUrl(item, currentUserId: auth.userId);
    final notifier = ref.read(blogProvider(HomeBlogTab.recommend).notifier);
    final showFollow = shouldShowBlogFollowButton(item, auth.userId);
    final following = blogFollowCare(item) == 1;
    final avatarHeroTag = avatarUrl != null
        ? blogAvatarDetailHeroTag(item)
        : null;

    return Stack(
      children: [
        BlogDetailBottomInfo(blog: item, bottomInset: bottomInset),
        DetailSideActionRail(
          bottomOffset: bottomInset,
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
          onLikeTap: () => notifier.onZanTap(item),
          onFollowTap: () => notifier.onCareTap(item),
          onCollectTap: () => notifier.onCollectTap(item),
          onShareTap: () => notifier.onShareTap(item),
          onCommentTap: onCommentTap,
        ),
      ],
    );
  }
}
