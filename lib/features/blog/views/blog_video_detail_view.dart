import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/video_player/video_ad_overlay.dart';
import 'package:qqai/features/blog/data/blog_detail_swipe_playlist.dart';
import 'package:qqai/features/blog/views/blog_video_detail_player.dart';

import '../../blog/data/models/blog_page_model.dart';
import 'package:qqai/features/blog/data/blog_browse_record.dart';
import '../../../router/app_routes.dart';
import 'package:qqai/components/blog/media_detail_shell.dart';

import '../../comment/providers/comment_providers.dart';
import 'blog_detail_comment_side_panel.dart';
import 'blog_detail_ui.dart';
import 'blog_detail_video_toolbar.dart';

class BlogVideoDetailView extends ConsumerStatefulWidget {
  final BlogItem blogItem;
  final String detailRoute;
  final String? mediaHeroTag;
  final VideoAdPlaybackState? videoAdInitialState;

  const BlogVideoDetailView({
    super.key,
    required this.blogItem,
    this.detailRoute = Routes.blogVideoDetailView,
    this.mediaHeroTag,
    this.videoAdInitialState,
  });

  @override
  ConsumerState<BlogVideoDetailView> createState() => _BlogVideoDetailView();
}

class _BlogVideoDetailView extends ConsumerState<BlogVideoDetailView> {
  late final BlogDetailCommentSidePanelLifecycle _commentSidePanel;
  bool _wideCommentPanelClosed = false;
  bool _allowPopWithResult = false;
  VideoAdPlaybackState? _videoAdState;

  List<BlogItem> _playlist = [];
  bool _playlistLoading = true;
  String? _playlistError;
  PageController? _pageController;
  int _currentPage = 0;
  int? _entryBlogId;

  @override
  void initState() {
    super.initState();
    _entryBlogId = widget.blogItem.id;
    _videoAdState = widget.videoAdInitialState;
    _commentSidePanel = BlogDetailCommentSidePanelLifecycle(
      ref.read(commentProvider.notifier),
    );
    _commentSidePanel.bind();
    recordBlogBrowseSilently(ref, widget.blogItem.id);
    _loadPlaylist();
  }

  @override
  void didUpdateWidget(BlogVideoDetailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.blogItem.id != widget.blogItem.id) {
      _entryBlogId = widget.blogItem.id;
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
    setState(() {
      _playlistLoading = true;
      _playlistError = null;
    });
    try {
      final commentState = ref.read(commentProvider);
      final collection = effectiveBlogDetailCollection(
        widget.blogItem,
        commentState.selectedCollection,
      );
      final items = await loadBlogDetailSwipePlaylist(
        ref: ref,
        currentBlog: widget.blogItem,
        collection: collection,
      );
      if (!mounted) return;
      final initialIndex = blogDetailSwipeInitialIndex(items, widget.blogItem);
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
        _playlist = [widget.blogItem];
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
    final isWideScreen = 1.sw > 900;
    final showCommentPanel =
        commentState.showComment || (isWideScreen && !_wideCommentPanelClosed);
    final currentBlog = _currentBlog;
    final sidePanelCollection = effectiveBlogDetailCollection(
      currentBlog,
      commentState.selectedCollection,
    );
    final showToolbarControlsRow = 1.sw > 800;
    final toolbarHeight = blogDetailVideoToolbarHeight(
      showControlsRow: showToolbarControlsRow,
    );

    return PopScope(
      canPop: _allowPopWithResult,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _popWithVideoAdState();
      },
      child: MediaDetailShell(
        showCommentPanel: showCommentPanel,
        sidePanelBlog: currentBlog,
        popResultBuilder: () => _videoAdState,
        onCommentClose: () => _toggleCommentPanel(
          commentNotifier,
          panelVisible: showCommentPanel,
          isWideScreen: isWideScreen,
        ),
        sidePanelInitialTabIndex: commentState.selectedTabIndex,
        sidePanelCollection: sidePanelCollection,
        sidePanelCollectionVideoDetailRoute: widget.detailRoute,
        content: _buildContent(
          commentNotifier: commentNotifier,
          showCommentPanel: showCommentPanel,
          isWideScreen: isWideScreen,
          showToolbarControlsRow: showToolbarControlsRow,
          toolbarHeight: toolbarHeight,
        ),
      ),
    );
  }

  BlogItem get _currentBlog {
    if (_playlist.isEmpty) return widget.blogItem;
    return _playlist[_currentPage.clamp(0, _playlist.length - 1)];
  }

  Widget _buildContent({
    required CommentNotifier commentNotifier,
    required bool showCommentPanel,
    required bool isWideScreen,
    required bool showToolbarControlsRow,
    required double toolbarHeight,
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
      return _buildVideoPage(
        blog: widget.blogItem,
        pageIndex: 0,
        commentNotifier: commentNotifier,
        showCommentPanel: showCommentPanel,
        isWideScreen: isWideScreen,
        showToolbarControlsRow: showToolbarControlsRow,
        toolbarHeight: toolbarHeight,
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
        return _buildVideoPage(
          blog: _playlist[index],
          pageIndex: index,
          commentNotifier: commentNotifier,
          showCommentPanel: showCommentPanel,
          isWideScreen: isWideScreen,
          showToolbarControlsRow: showToolbarControlsRow,
          toolbarHeight: toolbarHeight,
        );
      },
    );
  }

  Widget _buildVideoPage({
    required BlogItem blog,
    required int pageIndex,
    required CommentNotifier commentNotifier,
    required bool showCommentPanel,
    required bool isWideScreen,
    required bool showToolbarControlsRow,
    required double toolbarHeight,
  }) {
    final isActive = pageIndex == _currentPage;
    final useEntryHero = isActive && blog.id != null && blog.id == _entryBlogId;
    return Stack(
      fit: StackFit.expand,
      children: [
        BlogVideoDetailPlayer(
          key: ValueKey('blog_detail_video_${blog.id ?? pageIndex}'),
          blog: blog,
          mediaHeroTag: useEntryHero ? widget.mediaHeroTag : null,
          videoAdInitialState: useEntryHero ? widget.videoAdInitialState : null,
          onVideoAdStateChanged: isActive
              ? (state) {
                  _videoAdState = state;
                }
              : null,
          isActive: isActive,
          showToolbarControlsRow: showToolbarControlsRow,
          onCompleted: () => _goToNextPage(pageIndex),
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
    );
  }

  void _onPageChanged(int index) {
    if (index == _currentPage) return;
    setState(() => _currentPage = index);
    final blog = _playlist[index];
    recordBlogBrowseSilently(ref, blog.id);
    _selectCollectionTabIfNeeded(blog);
  }

  void _goToNextPage(int currentIndex) {
    if (currentIndex + 1 >= _playlist.length) return;
    final controller = _pageController;
    if (controller == null || !controller.hasClients) return;
    _showAutoPlayNextTip();
    controller.animateToPage(
      currentIndex + 1,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _popWithVideoAdState() {
    ref.read(commentProvider.notifier).dontShowComment();
    setState(() => _allowPopWithResult = true);
    context.pop(_videoAdState);
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

  void _showAutoPlayNextTip() {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('即将自动播放下一集'),
          duration: Duration(milliseconds: 1600),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
