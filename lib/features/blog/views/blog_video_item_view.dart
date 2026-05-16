import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'blog_comment_panel.dart';
import 'package:qqai/components/blog/creator_header_row.dart';
import 'package:qqai/components/blog/feed_action_bar.dart';
import 'package:qqai/components/blog/feed_video_more_menu.dart';
import 'package:qqai/components/blog/visibility_video_slot.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../../../providers/auth_providers.dart';
import '../data/blog_list_patch.dart';
import '../data/models/blog_page_model.dart';
import '../providers/blog_feed_list_actions.dart';
import '../providers/blog_providers.dart';
import '../../index/providers/home_follow_feed_providers.dart';
import '../../my/providers/my_shop_profile.dart';
import 'blog_detail_ui.dart';
import 'blog_list_kind.dart';

class BlogVideoItemView extends ConsumerStatefulWidget {
  final BlogItem blogItem;
  final int category;
  final BlogListKind listKind;

  BlogVideoItemView(
    this.category,
    this.blogItem, {
    this.listKind = BlogListKind.recommend,
  });

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
    final BlogFeedListActions blogNotifier = follow
        ? ref.read(homeFollowFeedProvider.notifier)
        : ref.read(blogProvider.notifier);
    final auth = ref.watch(authProvider);
    final myShop = switch (ref.watch(myShopProfileProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final showCareButton =
        shouldShowBlogFollowButton(widget.blogItem, auth.userId);
    final avatarUrl = blogCreatorAvatarUrl(
      widget.blogItem,
      currentUserId: auth.userId,
      fallbackAvatarUrl: myShop?.coverUrl,
    );
    final isWideScreen = 1.sw > 900;
    final item = resolveFeedBlogItem(
      ref,
      widget.blogItem,
      followFeed: follow,
    );
    final bodyStyle = context.typo.body;
    const String coverUrl = 'https://file.qqai.cn/qqai/2025/09/1.webp';
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
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  widget.blogItem.content ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: bodyStyle.copyWith(
                    fontSize: (bodyStyle.fontSize ?? 16),
                  ),
                ),
              ),
              Container(height: 2, color: Colors.white),
              Expanded(
                flex: 9,
                child: AspectRatio(
                  aspectRatio: 15 / 9,
                  child: VisibilityVideoSlot(
                    key: Key('blog_video_${widget.blogItem.id}'),
                    url: widget.blogItem.resources ?? '',
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
