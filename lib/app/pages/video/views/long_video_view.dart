import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qqai/app/pages/video/controllers/long_video_controller.dart';

import 'long_video_item_view.dart';

class LongVideoView extends GetView<LongVideoController> {
  const LongVideoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Material(
          child: Padding(
        padding: EdgeInsets.all(0),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 500.0,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                childAspectRatio: 3 / 2),
            itemCount: controller.videoItems.length,
            itemBuilder: (context, index) {
              return LongVideoItemView();
            }),
      ));
    });
  }
}
