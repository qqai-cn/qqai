import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/blog/network_image_carousel_pages.dart';
import 'package:qqai/features/blog/data/blog_detail_swipe_playlist.dart';
import 'package:qqai/features/blog/views/blog_video_detail_player.dart';
import 'package:qqai/components/blog/carousel_page_dots.dart';
import 'package:qqai/components/blog/media_detail_shell.dart';
import 'package:qqai/features/blog/views/blog_detail_ui.dart';
import 'package:qqai/features/blog/views/blog_detail_video_toolbar.dart';

import 'package:qqai/features/blog/data/blog_browse_record.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:video_player/video_player.dart';
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
  late final BlogDetailCommentSidePanelLifecycle _commentSidePanel;
  bool _wideCommentPanelClosed = false;

  List<BlogItem> _playlist = [];
  bool _playlistLoading = true;
  String? _playlistError;
  PageController? _pageController;
  int _currentPage = 0;
  int? _entryBlogId;

  @override
  void initState() {
    super.initState();
    _entryBlogId = widget.blogItem?.id;
    _commentSidePanel = BlogDetailCommentSidePanelLifecycle(
      ref.read(commentProvider.notifier),
    );
    _commentSidePanel.bind();
    recordBlogBrowseSilently(ref, widget.blogItem?.id);
    _loadPlaylist();
  }

  @override
  void didUpdateWidget(BlogImgDetailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.blogItem?.id != widget.blogItem?.id) {
      _entryBlogId = widget.blogItem?.id;
      _loadPlaylist();
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _commentSidePanel.unbind();
    super.dispose();
  }

  Future<void> _loadPlaylist() async {
    final current = widget.blogItem;
    if (current == null) {
      setState(() {
        _playlistLoading = false;
        _playlist = [];
      });
      return;
    }

    setState(() {
      _playlistLoading = true;
      _playlistError = null;
    });
    try {
      final commentState = ref.read(commentProvider);
      final collection = effectiveBlogDetailCollection(
        current,
        commentState.selectedCollection,
      );
      final items = await loadBlogDetailSwipePlaylist(
        ref: ref,
        currentBlog: current,
        collection: collection,
      );
      if (!mounted) return;
      final initialIndex = blogDetailSwipeInitialIndex(items, current);
      _pageController?.dispose();
      setState(() {
        _playlist = items;
        _playlistLoading = false;
        _currentPage = initialIndex;
        _pageController = PageController(initialPage: initialIndex);
      });
      _selectCollectionTabIfNeeded(items[initialIndex]);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _playlistLoading = false;
        _playlistError = e.toString();
        _playlist = [current];
        _currentPage = 0;
        _pageController?.dispose();
        _pageController = PageController();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentProvider);
    final commentNotifier = ref.read(commentProvider.notifier);
    final currentBlog = _currentBlog;
    final isWideScreen = 1.sw > 900;
    final showCommentPanel =
        commentState.showComment || (isWideScreen && !_wideCommentPanelClosed);

    return MediaDetailShell(
      showCommentPanel: showCommentPanel,
      sidePanelBlog: currentBlog,
      onCommentClose: () => _toggleCommentPanel(
        commentNotifier,
        panelVisible: showCommentPanel,
        isWideScreen: isWideScreen,
      ),
      sidePanelInitialTabIndex: commentState.selectedTabIndex,
      sidePanelCollection: effectiveBlogDetailCollection(
        currentBlog,
        commentState.selectedCollection,
      ),
      sidePanelCollectionVideoDetailRoute: Routes.blogImgDetailView,
      content: _buildContent(
        commentNotifier: commentNotifier,
        showCommentPanel: showCommentPanel,
        isWideScreen: isWideScreen,
      ),
    );
  }

  BlogItem get _currentBlog {
    if (_playlist.isEmpty) return widget.blogItem!;
    return _playlist[_currentPage.clamp(0, _playlist.length - 1)];
  }

  Widget _buildContent({
    required CommentNotifier commentNotifier,
    required bool showCommentPanel,
    required bool isWideScreen,
  }) {
    if (_playlistLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_playlistError != null && _playlist.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _playlistError!,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(onPressed: _loadPlaylist, child: const Text('重试')),
          ],
        ),
      );
    }

    final controller = _pageController;
    if (controller == null || _playlist.isEmpty) {
      return _BlogImgDetailPageContent(
        blog: widget.blogItem!,
        mediaHeroTag: widget.mediaHeroTag,
        isActive: true,
        onCommentTap: () => _toggleCommentPanel(
          commentNotifier,
          panelVisible: showCommentPanel,
          isWideScreen: isWideScreen,
        ),
      );
    }

    return PageView.builder(
      controller: controller,
      scrollDirection: Axis.vertical,
      physics: _playlist.length > 1
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: _playlist.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        final blog = _playlist[index];
        final useEntryHero =
            index == _currentPage && blog.id != null && blog.id == _entryBlogId;
        return _BlogImgDetailPageContent(
          key: ValueKey('blog_img_detail_${blog.id ?? index}'),
          blog: blog,
          mediaHeroTag: useEntryHero ? widget.mediaHeroTag : null,
          isActive: index == _currentPage,
          onCommentTap: () => _toggleCommentPanel(
            commentNotifier,
            panelVisible: showCommentPanel,
            isWideScreen: isWideScreen,
          ),
        );
      },
    );
  }

  void _onPageChanged(int index) {
    if (index == _currentPage) return;
    setState(() => _currentPage = index);
    recordBlogBrowseSilently(ref, _playlist[index].id);
    _selectCollectionTabIfNeeded(_playlist[index]);
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

  void _selectCollectionTabIfNeeded(BlogItem blog) {
    final collections = blog.collections ?? const <BlogItemCollection>[];
    if (collections.isEmpty) return;
    final commentState = ref.read(commentProvider);
    final collection = effectiveBlogDetailCollection(
      blog,
      commentState.selectedCollection,
    );
    if (collection != null) {
      ref.read(commentProvider.notifier).selectCollectionTab(collection);
    }
  }
}

class _BlogImgDetailPageContent extends ConsumerStatefulWidget {
  final BlogItem blog;
  final String? mediaHeroTag;
  final bool isActive;
  final VoidCallback onCommentTap;

  const _BlogImgDetailPageContent({
    super.key,
    required this.blog,
    this.mediaHeroTag,
    required this.isActive,
    required this.onCommentTap,
  });

  @override
  ConsumerState<_BlogImgDetailPageContent> createState() =>
      _BlogImgDetailPageContentState();
}

class _BlogImgDetailPageContentState extends ConsumerState<_BlogImgDetailPageContent>
    with WidgetsBindingObserver {
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();
  int _current = 0;
  VideoPlayerController? _backgroundMusicController;
  String? _backgroundMusicUrl;
  bool _resumeBackgroundMusicOnForeground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_syncBackgroundMusic(widget.blog));
  }

  @override
  void didUpdateWidget(_BlogImgDetailPageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.blog.id != widget.blog.id) {
      unawaited(_syncBackgroundMusic(widget.blog));
    }
    if (!widget.isActive && oldWidget.isActive) {
      unawaited(_backgroundMusicController?.pause());
    } else if (widget.isActive && !oldWidget.isActive) {
      unawaited(_backgroundMusicController?.play());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _backgroundMusicController;
    if (controller == null) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _resumeBackgroundMusicOnForeground = controller.value.isPlaying;
      unawaited(controller.pause());
      return;
    }
    if (state == AppLifecycleState.resumed &&
        _resumeBackgroundMusicOnForeground &&
        widget.isActive) {
      _resumeBackgroundMusicOnForeground = false;
      unawaited(controller.play());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_disposeBackgroundMusic());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blog = widget.blog;
    final hasVideo = blogItemHasVideoResources(blog.resources);
    final showToolbarControlsRow = 1.sw > 800;
    final toolbarHeight = blogDetailVideoToolbarHeight(
      showControlsRow: showToolbarControlsRow,
    );

    if (hasVideo) {
      return Stack(
        fit: StackFit.expand,
        children: [
          BlogVideoDetailPlayer(
            blog: blog,
            mediaHeroTag: widget.mediaHeroTag,
            isActive: widget.isActive,
            showToolbarControlsRow: showToolbarControlsRow,
          ),
          BlogDetailMediaOverlay(
            blog: blog,
            bottomInset: toolbarHeight,
            onCommentTap: widget.onCommentTap,
          ),
        ],
      );
    }

    return _buildImageCarousel(blog, toolbarHeight: toolbarHeight);
  }

  Widget _buildImageCarousel(BlogItem blog, {required double toolbarHeight}) {
    final imageUrls = parseCommaSeparatedUrls(blog.resources);
    final imageWidgets = buildNetworkImageCarouselPages(
      imageUrls,
      firstHeroTag: widget.mediaHeroTag,
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
            autoPlay: widget.isActive,
            onPageChanged: (index, reason) {
              setState(() => _current = index);
            },
          ),
        ),
        BlogDetailMediaOverlay(
          blog: blog,
          onCommentTap: widget.onCommentTap,
        ),
        CarouselPageDots(
          itemCount: imageUrls.length,
          currentIndex: _current,
          onDotTap: (index) => carouselSliderController.animateToPage(index),
        ),
      ],
    );
  }

  Future<void> _syncBackgroundMusic(BlogItem blog) async {
    final url = _imageBackgroundMusicUrl(blog);
    if (url == _backgroundMusicUrl) return;

    await _disposeBackgroundMusic();
    _backgroundMusicUrl = url;
    if (url == null) return;

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _backgroundMusicController = controller;
    try {
      await controller.initialize();
      await controller.setLooping(true);
      if (!mounted || _backgroundMusicController != controller) {
        await controller.dispose();
        return;
      }
      if (widget.isActive) {
        await controller.play();
      }
    } catch (_) {
      if (_backgroundMusicController == controller) {
        _backgroundMusicController = null;
        _backgroundMusicUrl = null;
      }
      await controller.dispose();
    }
  }

  Future<void> _disposeBackgroundMusic() async {
    final controller = _backgroundMusicController;
    _backgroundMusicController = null;
    _backgroundMusicUrl = null;
    _resumeBackgroundMusicOnForeground = false;
    if (controller == null) return;
    await controller.pause();
    await controller.dispose();
  }

  String? _imageBackgroundMusicUrl(BlogItem blog) {
    if (blog.blogType != 1 || blog.soundMode != 2) {
      return null;
    }
    final url = blog.backgroundMusicUrl?.trim();
    if (url == null || url.isEmpty) {
      return null;
    }
    return url;
  }
}
