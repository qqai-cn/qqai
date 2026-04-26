import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/features/blog/views/video_detail_palyer/video_detail_players.dart';

import '../../blog/data/models/blog_page_model.dart';
import 'package:qqai/components/blog/media_detail_shell.dart';

import '../../comment/providers/comment_providers.dart';

class BlogVideoDetailView extends ConsumerStatefulWidget {
  final BlogItem blogItem;

  const BlogVideoDetailView({super.key, required this.blogItem});

  @override
  ConsumerState<BlogVideoDetailView> createState() => _BlogVideoDetailView();
}

class _BlogVideoDetailView extends ConsumerState<BlogVideoDetailView> {
  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentProvider);
    return MediaDetailShell(
      showCommentPanel: commentState.showComment,
      content: const VideoDetailPlayers(),
    );
  }
}
