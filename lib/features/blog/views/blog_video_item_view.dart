import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'blog_comment_panel.dart';
import 'package:qqai/components/blog/creator_header_row.dart';
import 'package:qqai/components/blog/feed_action_bar.dart';
import 'package:qqai/components/blog/feed_video_more_menu.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/components/blog/visibility_video_slot.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../../../providers/auth_providers.dart';
import '../data/blog_display_text.dart';
import '../data/blog_list_patch.dart';
import '../data/home_blog_tab.dart';
import '../data/models/blog_page_model.dart';
import '../providers/blog_feed_list_actions.dart';
import '../providers/blog_providers.dart';
import '../../index/providers/home_follow_feed_providers.dart';
import 'blog_avatar_preview.dart';
import 'blog_detail_ui.dart';
import 'blog_list_kind.dart';

class BlogVideoItemView extends ConsumerStatefulWidget {
  final BlogItem blogItem;
  final int category;
  final BlogListKind listKind;

  const BlogVideoItemView(
    this.category,
    this.blogItem, {
    super.key,
    this.listKind = BlogListKind.recommend,
    this.feedActions,
  });

  /// 指定时用于广场等独立列表，覆盖 [listKind] / [blogProvider] 解析。
  final BlogFeedListActions? feedActions;

  @override
  ConsumerState<BlogVideoItemView> createState() {
    return _BlogVideoItemViewState();
  }
}

class _BlogVideoItemViewState extends ConsumerState<BlogVideoItemView> {
  String text = '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。';

  @override
  Widget build(BuildContext context) {
    final follow = widget.listKind == BlogListKind.followFeed;
    final BlogFeedListActions blogNotifier =
        widget.feedActions ??
        (follow
            ? ref.read(homeFollowFeedProvider.notifier)
            : ref.read(blogProvider(widget.category).notifier));
    final auth = ref.watch(authProvider);
    final showCareButton = shouldShowBlogFollowButton(
      widget.blogItem,
      auth.userId,
    );
    final avatarUrl = blogCreatorAvatarUrl(
      widget.blogItem,
      currentUserId: auth.userId,
    );
    final avatarHeroTag = avatarUrl != null
        ? blogAvatarHeroTag(widget.category, widget.blogItem)
        : null;
    final isWideScreen = 1.sw > 900;
    final item = widget.feedActions != null
        ? widget.blogItem
        : resolveFeedBlogItem(
            ref,
            widget.blogItem,
            followFeed: follow,
            feedCategory: widget.category,
          );
    final preview = blogVideoListPreview(item);
    final rewardText = _rewardText(item.content);
    final bodyStyle = context.typo.body;
    final coverUrl = resolveBlogCoverUrl(item);
    final videoUrl = firstPlayableVideoUrlFromResources(item.resources) ?? '';
    return Card(
      child: SizedBox(
        height: blogNotifier.getVideoItemHeightWithWidth(
          1.sw <= 800 ? 1 : 2,
          1.sw,
        ),
        child: Padding(
          padding: EdgeInsets.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CreatorHeaderRow(
                creatorName: widget.blogItem.creatorName ?? '未知用户',
                care: blogFollowCare(widget.blogItem),
                metaText: authorFollowerMetaText(widget.blogItem),
                avatarUrl: avatarUrl,
                creatorLevel: blogCreatorLevel(widget.blogItem),
                showCareButton: showCareButton,
                onCareTap: () => blogNotifier.onCareTap(widget.blogItem),
                avatarHeroTag: avatarHeroTag,
                onAvatarTap: avatarUrl != null && avatarHeroTag != null
                    ? () => blogNotifier.onBlogAvatarTap(
                        context,
                        widget.blogItem,
                        avatarHeroTag,
                        avatarUrl,
                      )
                    : null,
              ),
              if (preview.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: bodyStyle.copyWith(
                      fontSize: (bodyStyle.fontSize ?? 16),
                    ),
                  ),
                ),
              if (widget.category == HomeBlogTab.mutualAid &&
                  rewardText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 4),
                  child: _RewardAmountText(text: rewardText),
                ),
              Container(height: 2, color: Colors.white),
              Expanded(
                flex: 9,
                child: AspectRatio(
                  aspectRatio: 15 / 9,
                  child: VisibilityVideoSlot(
                    key: Key('blog_video_${widget.blogItem.id}'),
                    url: videoUrl,
                    imgUrl: coverUrl,
                  ),
                ),
              ),
              FeedActionBar(
                liked: blogLikedByMe(item),
                likeCount: item.zan,
                commentCount: item.commentCount,
                onLike: () => blogNotifier.onZanTap(item),
                shareCount: item.shareCount,
                onShare: () => blogNotifier.onShareTap(item),
                onMenuSelected: (value) {
                  if (value == '0') {
                    blogNotifier.onCollectTap(widget.blogItem);
                  }
                },
                onComment: () {
                  if (isWideScreen) {
                    blogNotifier.onBlogItemTap(context, widget.blogItem);
                  } else {
                    showBlogCommentSheet(context, widget.blogItem);
                  }
                },
                menuBuilder: (context) {
                  final collected = blogCollectedByMe(widget.blogItem);
                  final entries = feedVideoMoreMenuEntries(context);
                  if (entries.isNotEmpty && entries.first is PopupMenuItem) {
                    entries[0] = PopupMenuItem<String>(
                      value: '0',
                      child: Text(
                        collected ? '取消收藏' : '收藏',
                        style: context.typo.body.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    );
                  }
                  return entries;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RewardAmountText extends StatelessWidget {
  const _RewardAmountText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.workspace_premium_outlined,
          size: 15,
          color: Color(0xFFFF8A00),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.typo.caption.copyWith(
            color: const Color(0xFFFF8A00),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

String? _rewardText(String? content) {
  for (final line in (content ?? '').split('\n')) {
    final text = line.trim();
    if (text.startsWith('悬赏金额：')) {
      final amount = text.substring('悬赏金额：'.length).trim();
      return amount.startsWith('¥') ? '悬赏金额：$amount' : '悬赏金额：¥$amount';
    }
  }
  return null;
}
