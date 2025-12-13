import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndexController extends GetxController with GetTickerProviderStateMixin {
  final RxBool hasSearch = true.obs;

  // final tabTitle = <String>[].obs;

  // late TabController tabController;

  final Map<int, ScrollController> controllers = {};

  ScrollController getScrollController(int tabIndex) {
    if (!controllers.containsKey(tabIndex)) {
      controllers[tabIndex] = ScrollController();
      // 可以在这里添加监听器等
      // _controllers[tabIndex]!.addListener(() { ... });
    }
    return controllers[tabIndex]!;
  }

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
  //     '推荐',
  //     '关注',
  //     '本地',
  //     '广场',
  //     '商场',
  //     '聚力',
  //     '共享',
  //     '工具',
  //   ];
  // }

  void changeShowSearch(bool ifShow) {
    if (hasSearch.value != ifShow) {
      hasSearch.value = ifShow;
    }
  }

  // void changeTab(int tab){
  //   tabController.animateTo(tab);
  // }

  // void initTabView() {
  //   getTabviewMenu();
  //   tabController = TabController(
  //     length: tabTitle.length,
  //     vsync: this,
  //   )..addListener(() {
  //       //搜索框
  //       if (tabController.index == 0) {
  //         hasSearch.value = true;
  //       } else {
  //         hasSearch.value = false;
  //       }
  //     });
  // }

  void scrollToTop(int tabIndex) {
    final controller = controllers[tabIndex];
    if (controller != null && controller.hasClients) {
      controller.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      print(
          "⚠️ Cannot scroll Tab $tabIndex to top: Controller not initialized or no ScrollView attached.");
    }
  }

  @override
  void onClose() {
    // 遍历 Map 中的所有 Controller 并调用 dispose()
    controllers.values.forEach((controller) => controller.dispose());
    // 清空 Map，防止内存泄漏
    controllers.clear();
    // tabController.dispose();
    super.onClose();
  }
}
