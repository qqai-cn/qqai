import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../watchvideo/component_item.dart';
import '../../../watchvideo/wait_play_video_list.dart';
import '../providers/lookart_providers.dart';



//控制评论和下一个播放
class LookArtRight extends ConsumerWidget {
  const LookArtRight({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lookArtState = ref.watch(lookArtProvider);
    final lookArtNotifier = ref.read(lookArtProvider.notifier);
    
    if (lookArtState.tabController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Center(child: getTabBar(lookArtState, lookArtNotifier)),
      ),
      body: TabBarView(
        controller: lookArtState.tabController,
        children: [
          ComponentItem(),
          WaitPlayVideoList(title: '',),
        ],
      ),
    );
  }

  TabBar getTabBar(LookArtState lookArtState, LookArtNotifier lookArtNotifier) {
    return TabBar(
      controller: lookArtState.tabController, //控制器
      // isScrollable: true,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: lookArtNotifier.tabValues.map((e) {
        return Container(
          height: 40,
          width: 80,
          alignment: Alignment.center,
          child: Text(
            e,
            style: const TextStyle(
                color: Colors.black54, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }
}
