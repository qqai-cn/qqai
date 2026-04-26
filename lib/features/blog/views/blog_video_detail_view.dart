import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/features/blog/views/video_detail_palyer/video_detail_players.dart';

import '../../blog/data/models/blog_page_model.dart';
import '../../comment/providers/comment_providers.dart';
import 'components/blog_detail_scaffold.dart';

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
    return BlogDetailScaffold(
      showCommentPanel: commentState.showComment,
      content: const VideoDetailPlayers(),
    );
  }
}
