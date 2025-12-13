import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qqai/app/pages/lookart/controllers/look_art_controller.dart';

import '../../watchvideo/component_item.dart';
import '../../watchvideo/wait_play_video_list.dart';


//控制评论和下一个播放
class LookArtRight extends GetView<LookArtController>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Center(child: getTabBar()),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          ComponentItem(),
          WaitPlayVideoList(title: '',),
        ],
      ),
    );
  }

  TabBar getTabBar() {
    return TabBar(
      controller: controller.tabController, //控制器
      // isScrollable: true,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: controller.tabValues.map((e) {
        return Container(
          height: 40,
          width: 80,
          alignment: Alignment.center,
          child: Text(
            e,
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }
}
