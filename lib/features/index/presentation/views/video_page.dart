import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/features/video/views/video_view.dart';

import '../../../comment/providers/comment_providers.dart';
import '../../../comment/views/comment_list_two_view.dart';
import '../../../comment/views/comment_view.dart';

class VideoPage extends ConsumerStatefulWidget {
  const VideoPage({super.key});

  @override
  ConsumerState<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends ConsumerState<VideoPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = 1.sw > 800;
    final commentState = ref.watch(commentProvider);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(color: Colors.black, child: VideoView()),
                ),
                if (commentState.showComment && !isWideScreen)
                  SizedBox(
                    width: 1.sw,
                    height: 0.6.sh,
                    child: CommentListTwoView(),
                  ),
              ],
            ),
          ),
          if (commentState.showComment && isWideScreen)
            SizedBox(width: 350, height: 1.sh, child: CommentView()),
        ],
      ),
    );
  }
}
