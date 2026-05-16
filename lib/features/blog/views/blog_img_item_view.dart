import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_typography.dart';

import 'blog_comment_panel.dart';
import 'package:qqai/components/blog/creator_header_row.dart';
import 'package:qqai/components/blog/feed_action_bar.dart';
import 'package:qqai/components/blog/hero_image_wrap_grid.dart';

import '../../../../../constant/constant.dart';
import '../../../../providers/auth_providers.dart';
import '../data/blog_list_patch.dart';
import '../data/models/blog_page_model.dart';
import '../providers/blog_feed_list_actions.dart';
import '../providers/blog_providers.dart';
import '../../index/providers/home_follow_feed_providers.dart';
import '../../my/providers/my_shop_profile.dart';
import 'blog_avatar_preview.dart';
import 'blog_detail_ui.dart';
import 'blog_list_kind.dart';

class BlogImgItemView extends ConsumerStatefulWidget {
  final BlogItem blogItem;
  final int category;
  final BlogListKind listKind;

  BlogImgItemView(
    this.category,
    this.blogItem, {
    this.listKind = BlogListKind.recommend,
  });

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
    final BlogFeedListActions blogNotifier = follow
        ? ref.read(homeFollowFeedProvider.notifier)
        : ref.read(blogProvider(widget.category).notifier);
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
    final avatarHeroTag = avatarUrl != null
        ? blogAvatarHeroTag(widget.category, widget.blogItem)
        : null;
    final isWideScreen = 1.sw > 900;
    final item = resolveFeedBlogItem(
      ref,
      widget.blogItem,
      followFeed: follow,
      feedCategory: widget.category,
    );
    final bodyStyle = context.typo.body;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CreatorHeaderRow(
              creatorName: widget.blogItem.creatorName ?? '未知用户',
              care: blogFollowCare(widget.blogItem),
              metaText: authorFollowerMetaText(widget.blogItem),
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
              widget.blogItem.content ?? '',
              scrollPhysics: NeverScrollableScrollPhysics(),
              maxLines: 3,
              minLines: 1,
              style: bodyStyle.copyWith(
                fontSize: (bodyStyle.fontSize ?? 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 10),
            HeroImageWrapGrid(
              imageUrls: _imageUrls,
              heroTagBuilder: (i) =>
                  'lookBlogImg-${widget.category}-${widget.blogItem.id}-$i',
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

int getCount(int count) {
  if (count <= 3) {
    return count;
  } else {
    return 3;
  }
}
