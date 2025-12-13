import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageController extends GetxController
    with GetTickerProviderStateMixin {
  final tabTitle = <String>[].obs;

  late TabController tabController;

  @override
  void onInit() {
    initTabView();
    super.onInit();
  }

  @override
  void onReady() {
    // getDataFromApi();
    super.onReady();
  }

  void getTabviewMenu() {
    tabTitle.value = [
      '消息',
      '好友',
    ];
  }

  void initTabView() {
    getTabviewMenu();
    tabController = TabController(
      length: tabTitle.length,
      vsync: this,
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
