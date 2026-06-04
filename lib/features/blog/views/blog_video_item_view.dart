import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/blog/blog_local_location_button.dart';
import 'package:qqai/components/blog/creator_header_row.dart';
import 'package:qqai/components/blog/feed_action_bar.dart';
import 'package:qqai/components/blog/feed_video_more_menu.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/components/blog/visibility_video_slot.dart';
import 'package:qqai/components/video_player/video_aspect_ratio.dart';
import 'package:qqai/components/video_player/video_ad_overlay.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../../../providers/auth_providers.dart';
import '../../../../router/app_routes.dart';
import '../data/blog_display_text.dart';
import '../data/blog_list_patch.dart';
import '../data/blog_route_extra.dart';
import '../data/home_blog_tab.dart';
import '../data/models/blog_page_model.dart';
import '../providers/blog_feed_list_actions.dart';
import '../providers/blog_providers.dart';
import '../../index/providers/home_follow_feed_providers.dart';
import '../data/blog_detail_feed_resolver.dart';
import '../data/blog_feed_more_menu_handler.dart';
import 'blog_avatar_preview.dart';
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
  static const double _initialVideoAspectRatio = 15 / 9;
  static const double _portraitDisplayAspectRatio = 1.1875;

  String text = '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。';
  VideoAdPlaybackState? _videoAdState;

  @override
  void didUpdateWidget(covariant BlogVideoItemView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.blogItem.id != widget.blogItem.id) {
      _videoAdState = null;
    }
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
    final preview = blogVideoListPreview(item);
    final rewardText = _rewardText(item.content);
    final bodyStyle = context.typo.body;
    final coverUrl = resolveBlogCoverUrl(item);
    final videoUrl = firstPlayableVideoUrlFromResources(item.resources) ?? '';
    final mediaHeroTag = blogVideoDetailHeroTag(
      widget.category,
      widget.blogItem,
    );
    final storedAspectRatio = _validVideoAspectRatio(item.videoAspectRatio);
    if (storedAspectRatio != null) {
      return _buildVideoCard(
        context: context,
        item: item,
        blogNotifier: blogNotifier,
        showCareButton: showCareButton,
        avatarUrl: avatarUrl,
        avatarHeroTag: avatarHeroTag,
        preview: preview,
        rewardText: rewardText,
        bodyStyle: bodyStyle,
        coverUrl: coverUrl,
        videoUrl: videoUrl,
        mediaHeroTag: mediaHeroTag,
        aspectRatio: storedAspectRatio,
      );
    }
    return VideoAspectRatioBox(
      videoUrl: videoUrl,
      fallbackAspectRatio: _initialVideoAspectRatio,
      builder: (context, aspectRatio) {
        return _buildVideoCard(
          context: context,
          item: item,
          blogNotifier: blogNotifier,
          showCareButton: showCareButton,
          avatarUrl: avatarUrl,
          avatarHeroTag: avatarHeroTag,
          preview: preview,
          rewardText: rewardText,
          bodyStyle: bodyStyle,
          coverUrl: coverUrl,
          videoUrl: videoUrl,
          mediaHeroTag: mediaHeroTag,
          aspectRatio: aspectRatio,
        );
      },
    );
  }

  Widget _buildVideoCard({
    required BuildContext context,
    required BlogItem item,
    required BlogFeedListActions blogNotifier,
    required bool showCareButton,
    required String? avatarUrl,
    required String? avatarHeroTag,
    required String preview,
    required String? rewardText,
    required TextStyle bodyStyle,
    required String coverUrl,
    required String videoUrl,
    required String mediaHeroTag,
    required double aspectRatio,
  }) {
    return Card(
      child: SizedBox(
        height: _videoItemHeightWithAspectRatio(aspectRatio),
        child: Padding(
          padding: const EdgeInsets.all(2),
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
              Container(
                height: 2,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.white,
              ),
              Expanded(
                flex: 9,
                child: VisibilityVideoSlot(
                  key: Key('blog_video_${widget.blogItem.id}'),
                  url: videoUrl,
                  imgUrl: coverUrl,
                  videoId: widget.blogItem.id,
                  aspectRatio: aspectRatio,
                  playerHeroTag: mediaHeroTag,
                  videoAdInitialState: _videoAdState,
                  onVideoAdStateChanged: (state) {
                    _videoAdState = state;
                  },
                ),
              ),
              if (widget.category == HomeBlogTab.local &&
                  blogLocalLocationButtonVisible(item))
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 4),
                  child: BlogLocalLocationButton(item: item),
                ),
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
                onComment: () => _openVideoDetail(mediaHeroTag),
                menuBuilder: (context) {
                  final collected = blogCollectedByMe(item);
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

  double _videoItemHeightWithAspectRatio(double aspectRatio) {
    final colCount = 1.sw <= 800 ? 1 : 2;
    var widthItem = 1.sw;
    if (colCount > 1) {
      widthItem = widthItem * 0.5;
    }
    final displayAspectRatio = aspectRatio < 1
        ? _portraitDisplayAspectRatio
        : 15 / 9;
    return widthItem / displayAspectRatio + 150;
  }

  double? _validVideoAspectRatio(double? value) {
    if (value == null || !value.isFinite || value <= 0) return null;
    return value;
  }

  Future<void> _openVideoDetail(String mediaHeroTag) async {
    final result = await context.push<VideoAdPlaybackState?>(
      Routes.blogVideoDetailView,
      extra: blogDetailRouteExtra(
        widget.blogItem,
        mediaHeroTag: mediaHeroTag,
        videoAdState: _videoAdState,
      ),
    );
    if (!mounted || result == null) return;
    setState(() => _videoAdState = result);
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
