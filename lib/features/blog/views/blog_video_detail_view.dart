import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/features/blog/views/blog_video_detail_player.dart';

import '../../blog/data/models/blog_page_model.dart';
import 'package:qqai/features/blog/data/blog_browse_record.dart';
import '../../my/data/repos/profile_repo.dart';
import '../../../router/app_routes.dart';
import 'package:qqai/components/blog/media_detail_shell.dart';

import '../../comment/providers/comment_providers.dart';
import 'blog_detail_comment_side_panel.dart';
import 'blog_detail_ui.dart';
import 'blog_detail_video_toolbar.dart';

class BlogVideoDetailView extends ConsumerStatefulWidget {
  final BlogItem blogItem;
  final String detailRoute;

  const BlogVideoDetailView({
    super.key,
    required this.blogItem,
    this.detailRoute = Routes.blogVideoDetailView,
  });

  @override
  ConsumerState<BlogVideoDetailView> createState() => _BlogVideoDetailView();
}

class _BlogVideoDetailView extends ConsumerState<BlogVideoDetailView> {
  late final BlogDetailCommentSidePanelLifecycle _commentSidePanel;
  bool _openingNextCollectionVideo = false;
  bool _keepCommentPanelStateOnDispose = false;

  @override
  void initState() {
    super.initState();
    _commentSidePanel = BlogDetailCommentSidePanelLifecycle(
      ref.read(commentProvider.notifier),
    );
    _commentSidePanel.bind();
    recordBlogBrowseSilently(ref, widget.blogItem.id);
    _selectCollectionTabOnEnter();
  }

  @override
  void dispose() {
    if (!_keepCommentPanelStateOnDispose) {
      _commentSidePanel.unbind();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentProvider);
    final commentNotifier = ref.read(commentProvider.notifier);
    final blog = widget.blogItem;
    final sidePanelCollection = _effectiveCollection(
      blog,
      commentState.selectedCollection,
    );
    return MediaDetailShell(
      showCommentPanel: commentState.showComment,
      sidePanelBlog: blog,
      onCommentClose: commentNotifier.changeShowComment,
      sidePanelInitialTabIndex: commentState.selectedTabIndex,
      sidePanelCollection: sidePanelCollection,
      sidePanelCollectionVideoDetailRoute: widget.detailRoute,
      content: Stack(
        fit: StackFit.expand,
        children: [
          BlogVideoDetailPlayer(
            blog: blog,
            onCompleted: () => _openNextCollectionVideo(sidePanelCollection),
          ),
          BlogDetailMediaOverlay(
            blog: blog,
            bottomInset: kBlogDetailVideoToolbarHeight,
            onCommentTap: commentNotifier.changeShowComment,
          ),
        ],
      ),
    );
  }

  BlogItemCollection? _effectiveCollection(
    BlogItem blog,
    BlogItemCollection? selected,
  ) {
    final collections = blog.collections ?? const <BlogItemCollection>[];
    if (collections.isEmpty) return null;
    final selectedId = selected?.id;
    if (selectedId != null) {
      for (final collection in collections) {
        if (collection.id == selectedId) return collection;
      }
    }
    return collections.first;
  }

  void _selectCollectionTabOnEnter() {
    final collections =
        widget.blogItem.collections ?? const <BlogItemCollection>[];
    if (collections.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final commentState = ref.read(commentProvider);
      final collection = _effectiveCollection(
        widget.blogItem,
        commentState.selectedCollection,
      );
      if (collection != null) {
        ref.read(commentProvider.notifier).selectCollectionTab(collection);
      }
    });
  }

  Future<void> _openNextCollectionVideo(BlogItemCollection? collection) async {
    final collectionId = collection?.id;
    final currentId = widget.blogItem.id;
    if (_openingNextCollectionVideo ||
        collection == null ||
        collectionId == null ||
        currentId == null) {
      return;
    }
    final currentCollection = collection;
    _openingNextCollectionVideo = true;
    try {
      final detail = await ref
          .read(profileRepoProvider)
          .getCollectionDetail(collectionId);
      final videos = (detail.blogs ?? [])
          .where((b) => b.id != null && b.blogType == 2)
          .toList();
      final currentIndex = videos.indexWhere((b) => b.id == currentId);
      if (!mounted || currentIndex < 0 || currentIndex + 1 >= videos.length) {
        return;
      }
      final nextBlog = videos[currentIndex + 1].copyWith(
        collections: [currentCollection],
      );
      _showAutoPlayNextTip();
      _keepCommentPanelStateOnDispose = true;
      context.pushReplacement(widget.detailRoute, extra: nextBlog);
    } finally {
      _openingNextCollectionVideo = false;
    }
  }

  void _showAutoPlayNextTip() {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('即将自动播放下一集'),
          duration: const Duration(milliseconds: 1600),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
