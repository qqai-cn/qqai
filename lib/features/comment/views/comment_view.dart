import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/config/theme/my_fonts.dart';
import 'package:qqai/features/comment/views/wait_video_view.dart';

import '../../../config/theme/app_typography.dart';
import '../providers/comment_providers.dart';
import 'comment_list_view.dart';

class CommentView extends ConsumerStatefulWidget {
  const CommentView({super.key});

  @override
  ConsumerState<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends ConsumerState<CommentView>
    with TickerProviderStateMixin {
  late TabController tabController;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentProvider);
    final commentNotifier = ref.read(commentProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Center(child: getTabBar(commentNotifier)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              commentNotifier.changeShowComment();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          CommentListView(),
          WaitVideoView(title: ''),
        ],
      ),
    );
  }

  TabBar getTabBar(CommentNotifier commentNotifier) {
    return TabBar(
      controller: tabController, //控制器
      // isScrollable: true,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: commentNotifier.tabValues.map((e) {
        return Container(
          height: 40,
          width: 80,
          alignment: Alignment.center,
          child: Text(
            e,
            style: context.typo.sectionTitle.copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }
}
