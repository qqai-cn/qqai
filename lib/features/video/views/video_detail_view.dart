import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/features/video/views/video_detail_players.dart';

import '../../blog/data/models/blog_page_model.dart';
import '../../comment/providers/comment_providers.dart';
import '../../comment/views/comment_view.dart';

class VideoDetailView extends ConsumerStatefulWidget {
  final BlogItem blogItem;

  const VideoDetailView({super.key, required this.blogItem});

  @override
  ConsumerState<VideoDetailView> createState() => _VideoDetailView();
}

class _VideoDetailView extends ConsumerState<VideoDetailView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentProvider);
    final commentNotifier = ref.read(commentProvider.notifier);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  VideoDetailPlayers(),
                  Positioned(
                    left: 10,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_circle_left,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: commentState.showComment,
            child: SizedBox(
              width: 350,
              height: 1.sh,
              // height: double.infinity,
              child: CommentView(),
            ),
          ),
        ],
      ),
    );
  }
}
