import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/components/blog/async_masonry_feed.dart';

import '../providers/blog_providers.dart';
import 'blog_img_item_view.dart';
import 'blog_video_item_view.dart';

class BlogView extends ConsumerStatefulWidget {
  final int category;

  const BlogView(this.category, {super.key});

  @override
  ConsumerState<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends ConsumerState<BlogView> {
  @override
  Widget build(BuildContext context) {
    final blogState = ref.watch(blogProvider);
    final asyncItems = blogState.blogPageData.whenData(
      (data) => data.list ?? [],
    );
    return Scaffold(
      backgroundColor: Colors.black12,
      body: AsyncMasonryFeed(
        asyncItems: asyncItems,
        items: blogState.allItems,
        isLoadingMore: blogState.isLoadingMore,
        hasMore: blogState.hasMore,
        onRetry: () => ref.read(blogProvider.notifier).load(),
        onRefresh: () => ref.read(blogProvider.notifier).refresh(),
        onLoadMore: () => ref.read(blogProvider.notifier).loadMore(),
        itemBuilder: (context, index, blogItem) {
          if (blogItem.blogType == 1) {
            return BlogImgItemView(widget.category, blogItem);
          } else {
            return BlogVideoItemView(widget.category, blogItem);
          }
        },
      ),
    );
  }
}
