import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../index/presentation/providers/home_providers.dart';
import '../../../index/presentation/providers/index_providers.dart';
import '../providers/blog_providers.dart';
import 'blog_img_item_view.dart';
import 'blog_video_item_view.dart';

class BlogView extends ConsumerStatefulWidget {
  final int categary;

  const BlogView(this.categary, {super.key});

  @override
  ConsumerState<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends ConsumerState<BlogView> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    // 在 initState 中初始化，使用 postFrameCallback 延迟执行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initScrollController();
        _initColCount();
      }
    });
  }

  void _initScrollController() {
    final indexState = ref.read(indexProvider);
    if (indexState.controllers.containsKey(0)) {
      _scrollController = indexState.controllers[0];
    } else {
      // 延迟创建，避免在构建过程中修改 provider
      Future.microtask(() {
        if (mounted) {
          _scrollController = ref.read(indexProvider.notifier).getScrollController(0);
          setState(() {});
        }
      });
      // 临时创建一个 ScrollController
      _scrollController = ScrollController();
    }
  }

  void _initColCount() {
    // 延迟设置列数，避免在构建过程中修改 provider
    Future.microtask(() {
      if (mounted) {
        ref.read(homeProvider.notifier).setColCount(1.sw);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final blogState = ref.watch(blogProvider(widget.categary));
    final blogNotifier = ref.read(blogProvider(widget.categary).notifier);
    final homeState = ref.watch(homeProvider);
    final indexState = ref.watch(indexProvider);

    // 使用已初始化的 ScrollController 或从 state 中获取
    final scrollController = _scrollController ?? indexState.controllers[0] ?? ScrollController();

    return Scaffold(
      backgroundColor: Colors.black12,
      body: MasonryGridView.count(
        itemCount: blogState.blogItems.length,
        crossAxisCount: homeState.colCount,
        controller: scrollController,
        itemBuilder: (context, index) {
          final blogItem = blogState.blogItems[index];
            if (blogItem.blogType == 1) {
              return Card(
                child: BlogImgItemView(
                  blogItem: blogItem,
                  categary: widget.categary,
                  onAvatarTap: () => blogNotifier.onUserAvatarTap(context, blogItem),
                  onCardTap: () => blogNotifier.onBlogItemTap(context, blogItem),
                  onCareTap: () => blogNotifier.onCareTap(blogItem),
                  onZanTap: () => blogNotifier.onZanTap(blogItem),
                  onImgTap: (item, index, heroTag) => blogNotifier.onBlogImgItemTap(context, item, index, heroTag),
                ),
              );
          } else {
            return Card(
              child: SizedBox(
                height: blogNotifier.getVideoItemHeightWithWidth(homeState.colCount, 1.sw),
                child: BlogVideoItemView(
                  blogItem: blogItem,
                  categary: widget.categary,
                  onCardTap: () => blogNotifier.onBlogItemTap(context, blogItem),
                  onCareTap: () => blogNotifier.onCareTap(blogItem),
                  onZanTap: () => blogNotifier.onZanTap(blogItem),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
