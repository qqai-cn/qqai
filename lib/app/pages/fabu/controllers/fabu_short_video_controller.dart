import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/models/address_entity.dart';

class FabuShortVideoController extends GetxController{

  //菜单和路由
  final publishController = TextEditingController();

  late List<XFile> files = [];
  List<XFile> videoFiles = [];
  List<AddressEntity> addressList = [];
  List<String> whoCanSee = [];

  late AddressEntity? selAddressEntity = null;
  late String? whoCanSeeSel = '';
  late Map<int, String> huatiSel = {};

  @override
  void onInit() {
    super.onInit();
    whoCanSee.addAll([
      '公开',
      '私密',
      '仅好友可看',
    ]);
  }
}