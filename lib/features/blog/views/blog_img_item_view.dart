import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/config/theme/app_typography.dart';

import 'package:qqai/components/blog/blog_local_location_button.dart';
import 'package:qqai/components/blog/creator_header_row.dart';
import 'package:qqai/components/blog/feed_action_bar.dart';
import 'package:qqai/components/blog/hero_image_wrap_grid.dart';

import '../../../../../constant/constant.dart';
import '../../../../providers/auth_providers.dart';
import '../data/blog_route_extra.dart';
import '../data/home_blog_tab.dart';
import '../data/blog_feed_more_menu_handler.dart';
import '../data/blog_list_patch.dart';
import '../data/models/blog_page_model.dart';
import '../providers/blog_feed_list_actions.dart';
import '../providers/blog_providers.dart';
import '../../index/providers/home_follow_feed_providers.dart';
import 'blog_avatar_preview.dart';
import '../data/blog_detail_feed_resolver.dart';
import 'blog_list_kind.dart';

class BlogImgItemView extends ConsumerStatefulWidget {
  final BlogItem blogItem;
  final int category;
  final BlogListKind listKind;

  const BlogImgItemView(
    this.category,
    this.blogItem, {
    super.key,
    this.listKind = BlogListKind.recommend,
    this.feedActions,
  });

  /// 指定时用于广场等独立列表，覆盖 [listKind] / [blogProvider] 解析。
  final BlogFeedListActions? feedActions;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BlogImgItemViewState();
  }
}

class _BlogImgItemViewState extends ConsumerState<BlogImgItemView> {
  late final List<String> _imageUrls;
  String text = '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。';

  @override
  void initState() {
    super.initState();
    _imageUrls =
        widget.blogItem.resources
            ?.split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];
  }

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
    final item = widget.feedActions != null
        ? widget.blogItem
        : resolveFeedBlogItem(
            ref,
            widget.blogItem,
            followFeed: follow,
            feedCategory: widget.category,
          );
    final content = _contentWithoutReward(item.content);
    final rewardText = _rewardText(item.content);
    final bodyStyle = context.typo.body;
    final mediaHeroTag = blogImageDetailHeroTag(
      widget.category,
      widget.blogItem,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CreatorHeaderRow(
              creatorName: widget.blogItem.creatorName ?? '未知用户',
              care: blogFollowCare(widget.blogItem),
              metaText: authorFollowerMetaText(
                widget.blogItem,
                includeDistance: widget.category != HomeBlogTab.local,
              ),
              avatarUrl: avatarUrl,
              creatorLevel: blogCreatorLevel(widget.blogItem),
              avatarSize: Constant.HEAD_IMG_SEZE,
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
            SelectableText(
              content,
              scrollPhysics: NeverScrollableScrollPhysics(),
              maxLines: 3,
              minLines: 1,
              style: bodyStyle.copyWith(
                fontSize: (bodyStyle.fontSize ?? 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.category == HomeBlogTab.mutualAid &&
                rewardText != null) ...[
              SizedBox(height: 6),
              _RewardAmountText(text: rewardText),
            ],
            SizedBox(height: 10),
            HeroImageWrapGrid(
              imageUrls: _imageUrls,
              maxVisibleCount: 3,
              heroTagBuilder: (i) => blogImageDetailHeroTag(
                widget.category,
                widget.blogItem,
                index: i,
              ),
              onImageTap: (i, heroTag) {
                blogNotifier.onBlogImgItemTap(
                  context,
                  widget.blogItem,
                  i,
                  heroTag,
                  _imageUrls,
                );
              },
            ),
            if (widget.category == HomeBlogTab.local &&
                blogLocalLocationButtonVisible(item)) ...[
              const SizedBox(height: 6),
              BlogLocalLocationButton(item: item),
            ],
            FeedActionBar(
              liked: blogLikedByMe(item),
              likeCount: item.zan,
              commentCount: item.commentCount,
              onLike: () => blogNotifier.onZanTap(item),
              shareCount: item.shareCount,
              onShare: () => blogNotifier.onShareTap(item),
              onMenuSelected: (value) {
                handleBlogFeedMoreMenuSelection(
                  context: context,
                  ref: ref,
                  item: item,
                  value: value,
                  feedActions: blogNotifier,
                );
              },
              onComment: () => blogNotifier.onBlogItemTap(
                context,
                widget.blogItem,
                mediaHeroTag: mediaHeroTag,
              ),
              menuBuilder: (context) {
                final collected = blogCollectedByMe(item);
                return <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: '0',
                    child: Text(
                      collected ? '取消收藏' : '收藏',
                      style: context.typo.body.copyWith(color: Colors.black54),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: '1',
                    child: Text(
                      '举报',
                      style: context.typo.body.copyWith(color: Colors.black54),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: '2',
                    child: Text(
                      '不感兴趣',
                      style: context.typo.body.copyWith(color: Colors.black54),
                    ),
                  ),
                ];
              },
            ),
          ],
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
          style: context.typo.caption.copyWith(
            color: const Color(0xFFFF8A00),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

String _contentWithoutReward(String? content) {
  return (content ?? '')
      .split('\n')
      .where((line) => !line.trim().startsWith('悬赏金额：'))
      .join('\n')
      .trim();
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

int getCount(int count) {
  if (count <= 3) {
    return count;
  } else {
    return 3;
  }
}
