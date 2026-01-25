import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/responsive_masonry_grid.dart';

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
    return Scaffold(
      backgroundColor: Colors.black12,
      body: blogState.blogPageData.when(
        data: (data) => ResponsiveMasonryGrid(
          itemCount: data.list!.length,
          minColumnWidth: 400,
          itemBuilder: (context, index) {
            final blogItem = data.list![index];
            if (blogItem.blogType == 1) {
              return Card(child: BlogImgItemView(widget.category, blogItem));
            } else {
              return Card(
                child: SizedBox(
                  height: blogNotifier.getVideoItemHeightWithWidth(3, 1.sw),
                  child: BlogVideoItemView(widget.category, blogItem),
                ),
              );
            }
          },
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('加载失败: $err', style: const TextStyle(color: Colors.white)),
              ElevatedButton(
                onPressed: () => ref.read(blogProvider.notifier).load(),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
