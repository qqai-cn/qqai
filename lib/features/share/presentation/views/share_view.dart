import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../index/providers/home_providers.dart';
import '../../../index/providers/index_providers.dart';
import '../providers/share_providers.dart';
import 'share_img_item_view.dart';
import 'share_video_item_view.dart';

class ShareView extends ConsumerStatefulWidget {
  final int categary;

  const ShareView(this.categary, {super.key});

  @override
  ConsumerState<ShareView> createState() => _ShareViewState();
}

class _ShareViewState extends ConsumerState<ShareView> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initScrollController();
        _initColCount();
      }
    });
  }

  void _initScrollController() {
    _scrollController = ScrollController();
  }

  void _initColCount() {
    Future.microtask(() {
      if (mounted) {
        // ref.read(homeProvider.notifier).setColCount(1.sw);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final shareState = ref.watch(shareProvider(widget.categary));
    final shareNotifier = ref.read(shareProvider(widget.categary).notifier);
    final homeState = ref.watch(homeProvider);
    final indexState = ref.watch(indexProvider);

    final scrollController =  ScrollController();

    return Scaffold(
      backgroundColor: Colors.black12,
      body: MasonryGridView.count(
        itemCount: shareState.blogItems.length,
        crossAxisCount: 3,
        controller: scrollController,
        itemBuilder: (context, index) {
          final blogItem = shareState.blogItems[index];
          if (blogItem.blogType == 1) {
            return Card(
              child: ShareImgItemView(
                blogItem: blogItem,
                categary: widget.categary,
                onAvatarTap: () => shareNotifier.onUserAvatarTap(context, blogItem),
                onCardTap: () => shareNotifier.onBlogItemTap(context, blogItem),
                onCareTap: () => shareNotifier.onCareTap(blogItem),
                onZanTap: () => shareNotifier.onZanTap(blogItem),
                onImgTap: (item, imgIndex, heroTag) => shareNotifier.onBlogImgItemTap(context, item, imgIndex, heroTag),
              ),
            );
          } else {
            return Card(
              child: SizedBox(
                height: shareNotifier.getVideoItemHeightWithWidth(3, 1.sw),
                child: ShareVideoItemView(
                  blogItem: blogItem,
                  categary: widget.categary,
                  onCardTap: () => shareNotifier.onBlogItemTap(context, blogItem),
                  onCareTap: () => shareNotifier.onCareTap(blogItem),
                  onZanTap: () => shareNotifier.onZanTap(blogItem),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
