import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/features/blog/views/blog_detail_side_panel.dart';
import 'package:qqai/features/video/providers/video_recommend_providers.dart';
import 'package:qqai/features/video/views/video_view.dart';

import '../../../comment/providers/comment_providers.dart';

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
    final commentNotifier = ref.read(commentProvider.notifier);
    final currentBlog = ref.watch(videoRecommendCurrentBlogProvider);

    Widget? sidePanel;
    if (commentState.showComment && currentBlog != null) {
      sidePanel = BlogDetailSidePanel(
        key: ValueKey('video_side_${currentBlog.id}'),
        blog: currentBlog,
        onClose: commentNotifier.changeShowComment,
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(color: Colors.black, child: VideoView()),
                ),
                if (sidePanel != null && !isWideScreen)
                  SizedBox(
                    width: 1.sw,
                    height: 0.6.sh,
                    child: sidePanel,
                  ),
              ],
            ),
          ),
          if (sidePanel != null && isWideScreen)
            SizedBox(width: 350, height: 1.sh, child: sidePanel),
        ],
      ),
    );
  }
}
