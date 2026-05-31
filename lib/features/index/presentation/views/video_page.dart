import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/features/blog/views/blog_detail_side_panel.dart';
import 'package:qqai/features/index/presentation/widgets/lazy_shell_tab.dart';
import 'package:qqai/features/video/providers/video_recommend_providers.dart';
import 'package:qqai/features/video/views/video_view.dart';
import 'package:qqai/router/app_routes.dart';

import '../../../comment/providers/comment_providers.dart';
import '../../../blog/data/models/blog_page_model.dart';

class VideoPage extends ConsumerStatefulWidget {
  const VideoPage({super.key});

  @override
  ConsumerState<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends ConsumerState<VideoPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final isWideScreen = 1.sw > 800;
    final isActive = MainShellIndexScope.of(context).currentIndex == 1;
    final commentState = ref.watch(commentProvider);
    final commentNotifier = ref.read(commentProvider.notifier);
    final onRecommendSubTab = ref.watch(videoSubTabIndexProvider) == 0;
    final currentBlog = ref.watch(videoRecommendCurrentBlogProvider);
    final sidePanelCollection = _effectiveCollection(
      currentBlog,
      commentState.selectedCollection,
    );

    Widget? sidePanel;
    if (onRecommendSubTab && commentState.showComment && currentBlog != null) {
      sidePanel = BlogDetailSidePanel(
        key: ValueKey('video_side_${currentBlog.id}'),
        blog: currentBlog,
        onClose: commentNotifier.changeShowComment,
        initialTabIndex: commentState.selectedTabIndex,
        collection: sidePanelCollection,
        collectionVideoDetailRoute: Routes.videoDetailView,
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: VideoView(isActive: isActive),
                  ),
                ),
                if (sidePanel != null && !isWideScreen)
                  SizedBox(width: 1.sw, height: 0.6.sh, child: sidePanel),
              ],
            ),
          ),
          if (sidePanel != null && isWideScreen)
            SizedBox(width: 350, height: 1.sh, child: sidePanel),
        ],
      ),
    );
  }

  BlogItemCollection? _effectiveCollection(
    BlogItem? blog,
    BlogItemCollection? selected,
  ) {
    final collections = blog?.collections ?? const <BlogItemCollection>[];
    if (collections.isEmpty) return null;
    final selectedId = selected?.id;
    if (selectedId != null) {
      for (final collection in collections) {
        if (collection.id == selectedId) return collection;
      }
    }
    return collections.first;
  }
}
