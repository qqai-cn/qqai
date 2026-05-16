import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/components/blog/async_masonry_feed.dart';

import '../../index/providers/home_follow_feed_providers.dart';
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
    final blogState = follow
        ? ref.watch(homeFollowFeedProvider)
        : ref.watch(blogProvider);
    final asyncItems = blogState.blogPageData.whenData(
      (data) => data.list ?? [],
    );
    return Scaffold(
      backgroundColor: Colors.black12,
      body: AsyncMasonryFeed<BlogItem>(
        asyncItems: asyncItems,
        items: blogState.allItems,
        isLoadingMore: blogState.isLoadingMore,
        hasMore: blogState.hasMore,
        onRetry: () {
          if (follow) {
            ref.read(homeFollowFeedProvider.notifier).load();
          } else {
            ref.read(blogProvider.notifier).load();
          }
        },
        onRefresh: () async {
          if (follow) {
            await ref.read(homeFollowFeedProvider.notifier).refresh();
          } else {
            await ref.read(blogProvider.notifier).refresh();
          }
        },
        onLoadMore: () async {
          if (follow) {
            await ref.read(homeFollowFeedProvider.notifier).loadMore();
          } else {
            await ref.read(blogProvider.notifier).loadMore();
          }
        },
        itemBuilder: (context, index, blogItem) {
          if (blogItem.blogType == 1) {
            return BlogImgItemView(
              widget.category,
              blogItem,
              listKind: widget.listKind,
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
