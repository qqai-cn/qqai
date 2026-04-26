import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/blog/carousel_page_dots.dart';
import 'package:qqai/components/blog/media_detail_shell.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';

import '../../../components/blog/detail_side_action_rail.dart';
import '../../comment/providers/comment_providers.dart';
import '../data/models/help_page_model.dart';

class HelpImgDetailView extends ConsumerStatefulWidget {
  final HelpItem? blogItem;

  const HelpImgDetailView({super.key, this.blogItem});

  @override
  ConsumerState<HelpImgDetailView> createState() => _HelpImgDetailViewState();
}

class _HelpImgDetailViewState extends ConsumerState<HelpImgDetailView> {
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentProvider);
    final commentNotifier = ref.read(commentProvider.notifier);

    final imageUrls = parseCommaSeparatedUrls(widget.blogItem!.resources);
    final imageWidgets = buildNetworkImageCarouselPages(imageUrls);
    return MediaDetailShell(
      showCommentPanel: commentState.showComment,
      content: Stack(
        children: [
          CarouselSlider(
            carouselController: carouselSliderController,
            items: imageWidgets,
            options: CarouselOptions(
              height: 1.sh,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() => _current = index);
              },
            ),
          ),
          DetailSideActionRail(
            onCommentTap: () => commentNotifier.changeShowComment(),
          ),
          CarouselPageDots(
            itemCount: imageUrls.length,
            currentIndex: _current,
            onDotTap: (index) =>
                carouselSliderController.animateToPage(index),
          ),
        ],
      ),
    );
  }
}
