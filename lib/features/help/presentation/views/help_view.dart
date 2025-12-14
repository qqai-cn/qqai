import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../index/presentation/providers/home_providers.dart';
import '../../../index/presentation/providers/index_providers.dart';
import '../providers/help_providers.dart';
import 'help_img_item_view.dart';
import 'help_video_item_view.dart';

class HelpView extends ConsumerStatefulWidget {
  final int categary;

  const HelpView(this.categary, {super.key});

  @override
  ConsumerState<HelpView> createState() => _HelpViewState();
}

class _HelpViewState extends ConsumerState<HelpView> {
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
    final indexState = ref.read(indexProvider);
    if (indexState.controllers.containsKey(6)) {
      _scrollController = indexState.controllers[6];
    } else {
      Future.microtask(() {
        if (mounted) {
          _scrollController = ref.read(indexProvider.notifier).getScrollController(6);
          setState(() {});
        }
      });
      _scrollController = ScrollController();
    }
  }

  void _initColCount() {
    Future.microtask(() {
      if (mounted) {
        ref.read(homeProvider.notifier).setColCount(1.sw);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final helpState = ref.watch(helpProvider(widget.categary));
    final helpNotifier = ref.read(helpProvider(widget.categary).notifier);
    final homeState = ref.watch(homeProvider);
    final indexState = ref.watch(indexProvider);

    final scrollController = _scrollController ?? indexState.controllers[6] ?? ScrollController();

    return Scaffold(
      backgroundColor: Colors.black12,
      body: MasonryGridView.count(
        itemCount: helpState.blogItems.length,
        crossAxisCount: homeState.colCount,
        controller: scrollController,
        itemBuilder: (context, index) {
          final blogItem = helpState.blogItems[index];
          if (blogItem.blogType == 1) {
            return Card(
              child: HelpImgItemView(
                blogItem: blogItem,
                categary: widget.categary,
                onAvatarTap: () => helpNotifier.onUserAvatarTap(context, blogItem),
                onCardTap: () => helpNotifier.onBlogItemTap(context, blogItem),
                onCareTap: () => helpNotifier.onCareTap(blogItem),
                onZanTap: () => helpNotifier.onZanTap(blogItem),
                onImgTap: (item, imgIndex, heroTag) => helpNotifier.onBlogImgItemTap(context, item, imgIndex, heroTag),
              ),
            );
          } else {
            return Card(
              child: SizedBox(
                height: helpNotifier.getVideoItemHeightWithWidth(homeState.colCount, 1.sw),
                child: HelpVideoItemView(
                  blogItem: blogItem,
                  categary: widget.categary,
                  onCardTap: () => helpNotifier.onBlogItemTap(context, blogItem),
                  onCareTap: () => helpNotifier.onCareTap(blogItem),
                  onZanTap: () => helpNotifier.onZanTap(blogItem),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
