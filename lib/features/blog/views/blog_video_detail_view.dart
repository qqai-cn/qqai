import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/video_player_detail/detail_video_player.dart';
import '../../../components/video_player_detail/myvideo_play.dart';
import '../../blog/data/models/blog_page_model.dart';
import '../../comment/providers/comment_providers.dart';
import '../../comment/views/comment_view.dart';

class BlogVideoDetailView extends ConsumerStatefulWidget {
  final BlogItem blogItem;

  const BlogVideoDetailView({super.key, required this.blogItem});

  @override
  ConsumerState<BlogVideoDetailView> createState() => _BlogVideoDetailView();
}

class _BlogVideoDetailView extends ConsumerState<BlogVideoDetailView> {
  final TextEditingController _controller = TextEditingController();
  bool showComment = true;

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

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  DetailVideoPlayer(),
                  MyVideo(
                    id: widget.blogItem.id!,
                    url: widget.blogItem.resources!,
                    color: Colors.black,
                    categary: 2,
                  ),
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
