import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../data/models/address_entity.dart';

class FabuGoodsController extends GetxController {

  //菜单和路由
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final priceController = TextEditingController();

  late List<XFile> files = [];
  List<XFile> videoFiles = [];
  List<AddressEntity> addressList = [];
  List<String> whoCanSee = [];

  late AddressEntity? selAddressEntity = null;
  late String? whoCanSeeSel = '';
  late Map<int, String> huatiSel = {};

  @override
  void onInit() {
    loadAddressData();
    whoCanSee.addAll([
      '公开',
      '私密',
      '仅好友可看',
    ]);
    super.onInit();
  }

  void setWhoCanSee(String who) {
    whoCanSeeSel = who;
    update();
  }

  void setHuati(Map<int,String> huati) {
    huatiSel = huati;
    update();
  }

  void setAddress(AddressEntity addressEntity) {
    selAddressEntity = addressEntity;
    update();
  }

  void loadAddressData() async {
    //加载联系人列表
    rootBundle.loadString('mock/address.json').then((value) {
      List list = json.decode(value);
      list.forEach((v) {
        addressList.add(AddressEntity.fromJson(v));
      });
    });
  }

  void clearList(XFile file) {
    files.remove(file);
    videoFiles.clear();
    update();
  }

  void clearVideo() {
    videoFiles.clear();
    update();
  }

  void selectFile(List<XFile> value, context) {
    bool allEmpty = files.isNotEmpty && videoFiles.isNotEmpty;
    if (allEmpty) {
      clearVideo();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        desc: '请上传图片',
        btnOkOnPress: () {},
      )..show();
      update();
      return;
    }
    if (files.length + value.length > 6) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        desc: '图片超出最大限制：6个',
        btnOkOnPress: () {},
      )..show();
      update();
      return;
    }
    if (value.isNotEmpty) {
      files.addAll(value);
    }
    update();
  }

  @override
  void onClose() {
    super.onClose();
    // titleController.dispose();
    // contentController.dispose();
    // priceController.dispose();
  }
}
