import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/components/blog/media_detail_shell.dart';
import 'package:qqai/components/video_player_detail/detail_video_player.dart';
import 'package:qqai/components/video_player_detail/myvideo_play.dart';

import '../../blog/views/video_detail_palyer/video_detail_players.dart';
import '../../comment/providers/comment_providers.dart';
import '../data/models/help_page_model.dart';

class HelpVideoDetailView extends ConsumerStatefulWidget {
  final HelpItem blogItem;

  const HelpVideoDetailView({super.key, required this.blogItem});

  @override
  ConsumerState<HelpVideoDetailView> createState() => _HelpVideoDetailViewState();
}

class _HelpVideoDetailViewState extends ConsumerState<HelpVideoDetailView> {
  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentProvider);
    return MediaDetailShell(
      showCommentPanel: commentState.showComment,
      content: const VideoDetailPlayers(),
    );
  }
}
