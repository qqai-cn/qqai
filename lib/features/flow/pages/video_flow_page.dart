import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/imgpreview/comment_panel.dart';
import '../../../components/video_player_detail/detail_video_player.dart';
import '../../../components/video_player_detail/myvideo_play.dart';
import '../../blog/domain/blog_page_model.dart';
import '../providers/flow_providers.dart';

class VideoFlowPage extends ConsumerStatefulWidget {
  final BlogItem blogItem;

  const VideoFlowPage({super.key, required this.blogItem});

  @override
  ConsumerState<VideoFlowPage> createState() => _VideoFlowPage();
}

class _VideoFlowPage extends ConsumerState<VideoFlowPage> {
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
    final flowState = ref.watch(flowProvider);
    final flowNotifier = ref.read(flowProvider.notifier);
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
                    blogItem: widget.blogItem,
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
          CommentPanel(),
        ],
      ),
    );
  }
}
