import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/features/blog/views/blog_video_detail_player.dart';

import '../../blog/data/models/blog_page_model.dart';
import 'package:qqai/components/blog/media_detail_shell.dart';

import '../../comment/providers/comment_providers.dart';
import 'blog_detail_comment_side_panel.dart';

class BlogVideoDetailView extends ConsumerStatefulWidget {
  final BlogItem blogItem;

  const BlogVideoDetailView({super.key, required this.blogItem});

  @override
  ConsumerState<BlogVideoDetailView> createState() => _BlogVideoDetailView();
}

class _BlogVideoDetailView extends ConsumerState<BlogVideoDetailView> {
  late final BlogDetailCommentSidePanelLifecycle _commentSidePanel;

  @override
  void initState() {
    super.initState();
    _commentSidePanel = BlogDetailCommentSidePanelLifecycle(
      ref.read(commentProvider.notifier),
    );
    _commentSidePanel.bind();
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
    final blog = widget.blogItem;
    return MediaDetailShell(
      showCommentPanel: commentState.showComment,
      sidePanelBlog: blog,
      onCommentClose: commentNotifier.changeShowComment,
      content: BlogVideoDetailPlayer(blog: blog),
    );
  }
}
