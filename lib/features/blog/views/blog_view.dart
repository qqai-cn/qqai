import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/blog/async_masonry_feed.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/providers/auth_providers.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/media_video_precache.dart';

import '../../index/providers/home_follow_feed_providers.dart';
import '../data/blog_route_extra.dart';
import '../data/models/blog_page_model.dart';
import '../providers/blog_providers.dart';
import 'blog_img_item_view.dart';
import 'blog_list_kind.dart';
import 'blog_video_item_view.dart';

class BlogView extends ConsumerStatefulWidget {
  final int category;
  final BlogListKind listKind;

  const BlogView(
    this.category, {
    super.key,
    this.listKind = BlogListKind.recommend,
  });

  @override
  ConsumerState<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends ConsumerState<BlogView> {
  @override
  Widget build(BuildContext context) {
    final follow = widget.listKind == BlogListKind.followFeed;
    if (follow && !ref.watch(authProvider).isAuthenticated) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '登录后查看关注的作品',
                style: context.typo.body.copyWith(
                  color: AppActionColors.strong(context),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.push(Routes.login),
                child: const Text('登录'),
              ),
            ],
          ),
        ),
      );
    }
    final blogState = follow
        ? ref.watch(homeFollowFeedProvider)
        : ref.watch(blogProvider(widget.category));
    final asyncItems = blogState.blogPageData.whenData(
      (data) => data.list ?? [],
    );
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AsyncMasonryFeed<BlogItem>(
        asyncItems: asyncItems,
        items: blogState.allItems,
        isLoadingMore: blogState.isLoadingMore,
        isRefreshing: blogState.isRefreshing,
        hasMore: blogState.hasMore,
        onRetry: () {
          if (follow) {
            ref.read(homeFollowFeedProvider.notifier).load();
          } else {
            ref.read(blogProvider(widget.category).notifier).load();
          }
        },
        onRefresh: () async {
          if (follow) {
            await ref.read(homeFollowFeedProvider.notifier).refresh();
          } else {
            await ref.read(blogProvider(widget.category).notifier).refresh();
          }
        },
        onLoadMore: () async {
          if (follow) {
            await ref.read(homeFollowFeedProvider.notifier).loadMore();
          } else {
            await ref.read(blogProvider(widget.category).notifier).loadMore();
          }
        },
        videoUrlForPrecache: blogItemVideoUrlForPrecache,
        precacheVideoAheadCount: 2,
        itemBuilder: (context, index, blogItem) {
          final heroScope = blogFeedListItemHeroScope(
            category: widget.category,
            listIndex: index,
            prefix: widget.listKind.name,
          );
          if (blogItem.blogType == 1) {
            return BlogImgItemView(
              widget.category,
              blogItem,
              listKind: widget.listKind,
              heroScope: heroScope,
            );
          } else {
            return BlogVideoItemView(
              widget.category,
              blogItem,
              listKind: widget.listKind,
            );
          }
        },
      ),
    );
  }
}
