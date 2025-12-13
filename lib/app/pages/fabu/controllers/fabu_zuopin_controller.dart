import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qqai/app/pages/fabu/views/fabu_goods_page.dart';

import '../views/fabu_aixin_page.dart';
import '../views/fabu_dynamic_page.dart';
import '../views/fabu_video_page.dart';
import 'fabu_dynamic_controller.dart';

class FabuZuoPinController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late FabuDynamicController fabuDynamicController = Get.put(FabuDynamicController());

  //tab控制
  late TabController tabController;
  late List<String> tabTitle = [
    '发布动态',
    '发布视频',
    '发布商品',
    '发布爱心',
  ];
  late List<Widget> tabBoby = [
    FabuDynamicPage(),
    FabuVideoPage(),
    FabuGoodsPage(),
    FabuAiXinPage(),
  ];

  void fabu(){
    int index =  tabController.index;
    if(index == 1){
      fabuDynamicController.fabu();
    }else if(index ==2){

    }
  }

  @override
  void onInit() {
    tabController = TabController(
      length: tabTitle.length,
      vsync: this,
    );
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose(); // 清理 TabController
    super.onClose();
  }
}
