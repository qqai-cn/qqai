import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/config/theme/my_fonts.dart';

import '../../../watchvideo/wait_play_video_list.dart';
import '../providers/lookart_providers.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';

//控制评论和下一个播放

class LookArtRight extends ConsumerStatefulWidget {
  LookArtRight();

  @override
  ConsumerState<LookArtRight> createState() {
    return _LookArtRight();
  }
}

class _LookArtRight extends ConsumerState<LookArtRight>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lookArtNotifier = ref.read(lookArtProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppActionColors.surface(context),
        title: Center(child: getTabBar(lookArtNotifier)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // ref.read(commentPanelVisibleProvider.notifier).state = false;
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          WaitPlayVideoList(title: ''),
        ],
      ),
    );
  }

  TabBar getTabBar(LookArtNotifier lookArtNotifier) {
    return TabBar(
      controller: tabController, //控制器
      // isScrollable: true,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: lookArtNotifier.tabValues.map((e) {
        return Container(
          height: 40,
          width: 80,
          alignment: Alignment.center,
          child: Text(
            e,
            style: context.typo.tab.copyWith(color: AppActionColors.muted(context), fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }
}
