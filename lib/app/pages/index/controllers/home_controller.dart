import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qqai/app/pages/index/views/index_page.dart';
import 'package:qqai/app/pages/index/views/me_page.dart';
import 'package:qqai/app/pages/index/views/message_page.dart';
import 'package:qqai/app/pages/index/views/video_page.dart';

import '../../../components/AnimatedBottomBar.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  TabController? tabController;
  final RxBool hasSearch = true.obs;

  String imgPath = 'imgs/';
  final selected = 0.obs;
  final bottomMenuType = 1.obs;
  final tabTitle = <String>[].obs;
  final colCount = 2.obs;

  // 定义一个工厂函数列表，而不是实例列表
  final List<Widget Function()> mainPageBuilders = [
    () => IndexPage(),
    () => VideoPage(),
    () => MessagePage(),
    () => MePage(),
  ];

  List<String> getTabviewMenu(int index) {
    switch (index) {
      case 0:
        return ['推荐', '关注', '本地', '广场', '商场', '聚力', '共享', '工具'];
      case 1:
        return ['影视', '芊视'];
      case 2:
        return ['消息', '好友'];
      default:
        return [];
    }
  }

  void initTabView(int index) {
    final titles = getTabviewMenu(index);
    tabTitle.value = titles;
    // ✅ 安全释放旧 controller
    // if (tabController != null && index != 0) {
    //   tabController!.dispose();
    // }
    tabController = TabController(
      length: titles.length,
      vsync: this,
      initialIndex: 0,
    )..addListener((_handleTabChange));
  }

  void _handleTabChange() {
    if (selected.value == 0 && tabController?.index == 0) {
      hasSearch.value = true;
    } else {
      hasSearch.value = false;
    }
  }

  void changeTab(int tab) {
    if (tabController != null && tab >= 0 && tab < tabController!.length) {
      tabController?.animateTo(tab);
    }
  }

// 在 changeMainPage 中
  void changeMainPage(int index) {
    if (index >= 0 && index < mainPageBuilders.length) {
      selected.value = index;
      initTabView(index);
      _handleTabChange();
    }
  }

  final List<BarItem> barItems = [
    BarItem(
      text: "首页",
      selectPath: "imgs/index-selv2.svg",
      unSelectPath: "imgs/index.svg",
      color: Colors.indigo,
    ),
    BarItem(
      text: "影视",
      selectPath: "imgs/video-sel.svg",
      unSelectPath: "imgs/video.svg",
      color: Colors.purple,
    ),
    BarItem(
      text: "消息",
      selectPath: "imgs/msg-selv2.svg",
      unSelectPath: "imgs/msg.svg",
      color: Colors.yellow.shade900,
    ),
    BarItem(
      text: "我的",
      selectPath: "imgs/me-selv2.svg",
      unSelectPath: "imgs/me.svg",
      color: Colors.teal,
    ),
  ];

  void setColCount(double len) {
    if (len < 1000) {
      colCount.value = 1;
    } else {
      colCount.value = 2;
    }
  }

  @override
  void onInit() {
    changeMainPage(0);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController?.removeListener(_handleTabChange);
    tabController?.dispose();
    super.onClose();
  }
}
