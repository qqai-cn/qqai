import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/blog_providers.dart';
import 'blog_img_item_view.dart';
import 'blog_video_item_view.dart';
import 'components/blog_feed_grid.dart';

class BlogView extends ConsumerStatefulWidget {
  final int category;

  const BlogView(this.category, {super.key});

  @override
  ConsumerState<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends ConsumerState<BlogView> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blogState = ref.watch(blogProvider);
    final blogNotifier = ref.read(blogProvider.notifier);
    final asyncItems = blogState.blogPageData.whenData(
      (data) => data.list ?? [],
    );
    return Scaffold(
      backgroundColor: Colors.black12,
      body: BlogFeedGrid(
        asyncItems: asyncItems,
        onRetry: () => ref.read(blogProvider.notifier).load(),
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
