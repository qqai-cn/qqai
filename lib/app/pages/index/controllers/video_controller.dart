import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../constant/api_constant.dart';
import '../../../data/models/skuu_blog_page_entity.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';
import '../../demo/flickvideo/short_video_player/homepage/short_video_homepage.dart';
import '../../video/myvideo_long_item.dart';

class VideoController extends GetxController with GetTickerProviderStateMixin {
  // final tabTitle = <String>[].obs;

  // late TabController tabController;

  @override
  void onInit() {
    // initTabView();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  // void getTabviewMenu() {
  //   tabTitle.value = [
  //     '影视',
  //     '短视频',
  //   ];
  // }
  //
  // void initTabView() {
  //   getTabviewMenu();
  //   tabController = TabController(
  //     length: tabTitle.length,
  //     vsync: this,
  //   );
  // }

  @override
  void onClose() {
    // tabController.dispose();
    super.onClose();
  }
}
