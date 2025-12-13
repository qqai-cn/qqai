import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../data/models/skuu_blog_page_entity.dart';

class MeController extends GetxController {
  final name = 1.obs;
  List<dynamic>? data;
  final controller = TextEditingController();
  late List<SkuuBlogPageDataRecords> skuuBlogPageDataRecords = [];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    // getDataFromApi();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
