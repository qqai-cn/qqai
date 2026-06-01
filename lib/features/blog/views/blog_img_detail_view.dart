import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/features/blog/views/blog_video_detail_player.dart';
import 'package:qqai/components/blog/carousel_page_dots.dart';
import 'package:qqai/components/blog/media_detail_shell.dart';
import 'package:qqai/features/blog/views/blog_detail_ui.dart';
import 'package:qqai/features/blog/views/blog_detail_video_toolbar.dart';

import 'package:qqai/features/blog/data/blog_browse_record.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import '../../comment/providers/comment_providers.dart';
import 'blog_detail_comment_side_panel.dart';

class BlogImgDetailView extends ConsumerStatefulWidget {
  final BlogItem? blogItem;
  final String? mediaHeroTag;

  const BlogImgDetailView({super.key, this.blogItem, this.mediaHeroTag});

  @override
  ConsumerState<BlogImgDetailView> createState() => _BlogImgDetailView();
}

class _BlogImgDetailView extends ConsumerState<BlogImgDetailView> {
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();
  int _current = 0;
  late final BlogDetailCommentSidePanelLifecycle _commentSidePanel;
  bool _wideCommentPanelClosed = false;

  @override
  void initState() {
    super.initState();
    _commentSidePanel = BlogDetailCommentSidePanelLifecycle(
      ref.read(commentProvider.notifier),
    );
    _commentSidePanel.bind();
    recordBlogBrowseSilently(ref, widget.blogItem?.id);
  }

  @override
  void dispose() {
    _commentSidePanel.unbind();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentProvider);
    final commentNotifier = ref.read(commentProvider.notifier);

    final blog = widget.blogItem!;
    final isWideScreen = 1.sw > 900;
    final showCommentPanel =
        commentState.showComment || (isWideScreen && !_wideCommentPanelClosed);
    final hasVideo = blogItemHasVideoResources(blog.resources);
    final showToolbarControlsRow = 1.sw > 800;
    final toolbarHeight = blogDetailVideoToolbarHeight(
      showControlsRow: showToolbarControlsRow,
    );

    return MediaDetailShell(
      showCommentPanel: showCommentPanel,
      sidePanelBlog: blog,
      onCommentClose: () => _toggleCommentPanel(
        commentNotifier,
        panelVisible: showCommentPanel,
        isWideScreen: isWideScreen,
      ),
      sidePanelInitialTabIndex: commentState.selectedTabIndex,
      sidePanelCollection: commentState.selectedCollection,
      content: hasVideo
          ? Stack(
              fit: StackFit.expand,
              children: [
                BlogVideoDetailPlayer(
                  blog: blog,
                  mediaHeroTag: widget.mediaHeroTag,
                  showToolbarControlsRow: showToolbarControlsRow,
                ),
                BlogDetailMediaOverlay(
                  blog: blog,
                  bottomInset: toolbarHeight,
                  onCommentTap: () => _toggleCommentPanel(
                    commentNotifier,
                    panelVisible: showCommentPanel,
                    isWideScreen: isWideScreen,
                  ),
                ),
              ],
            )
          : _buildImageCarousel(
              blog,
              commentNotifier,
              mediaHeroTag: widget.mediaHeroTag,
              panelVisible: showCommentPanel,
              isWideScreen: isWideScreen,
            ),
    );
  }

  void _toggleCommentPanel(
    CommentNotifier notifier, {
    required bool panelVisible,
    required bool isWideScreen,
  }) {
    final providerVisible = ref.read(commentProvider).showComment;
    if (panelVisible && !providerVisible && isWideScreen) {
      setState(() => _wideCommentPanelClosed = true);
      return;
    }
    setState(() {
      _wideCommentPanelClosed = providerVisible;
    });
    notifier.changeShowComment();
  }

  Widget _buildImageCarousel(
    BlogItem blog,
    CommentNotifier commentNotifier, {
    String? mediaHeroTag,
    required bool panelVisible,
    required bool isWideScreen,
  }) {
    final imageUrls = parseCommaSeparatedUrls(blog.resources);
    final imageWidgets = buildNetworkImageCarouselPages(
      imageUrls,
      firstHeroTag: mediaHeroTag,
      fit: BoxFit.contain,
    );
    return Stack(
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
        BlogDetailMediaOverlay(
          blog: blog,
          onCommentTap: () => _toggleCommentPanel(
            commentNotifier,
            panelVisible: panelVisible,
            isWideScreen: isWideScreen,
          ),
        ),
        CarouselPageDots(
          itemCount: imageUrls.length,
          currentIndex: _current,
          onDotTap: (index) => carouselSliderController.animateToPage(index),
        ),
      ],
    );
  }
}
