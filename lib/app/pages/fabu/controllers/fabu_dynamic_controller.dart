import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:qqai/app/data/models/weather_city_entity.dart';
import 'package:qqai/app/services/base_client.dart';
import 'package:qqai/constant/api_constant.dart';

import '../../../data/models/address_entity.dart';
import '../../../data/models/skuu_blog_save_entity.dart';
import '../../../services/api_call_status.dart';
import 'fabu_zuopin_controller.dart';

class FabuDynamicController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  //菜单和路由
  final publishController = TextEditingController();

  late List<XFile> files = [];
  List<XFile> videoFiles = [];
  List<AddressEntity> addressList = [];
  List<String> whoCanSee = [];

  late AddressEntity? selAddressEntity = null;
  late int? whoCanSeeSel = 0;
  late Map<int, String> huatiSel = {};
  late int blogType;

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

  void setWhoCanSee(int who) {
    whoCanSeeSel = who;
    update();
  }

  void setHuati(Map<int, String> huati) {
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

  void fabu() {
    SkuuBlogSaveEntity saveEntity = SkuuBlogSaveEntity();
    blogType = videoFiles.isEmpty ? 2 : 1;
    List<String> resources = [];
    List<XFile> resourcesAll = [];
    resourcesAll.addAll(files);
    resourcesAll.addAll(videoFiles);
    resourcesAll.forEach((XFile xFile) => {

    });
    saveEntity.resources = resources.join(",");
    saveEntity.content = publishController.text;
    saveEntity.blogType = blogType;
    saveEntity.addressId = selAddressEntity!.id;
    saveEntity.categary = 1;
    saveEntity.shareType = whoCanSeeSel!;
    saveEntity.squareId = 1;
    saveEntity.topicIds = huatiSel.keys.join(",");

    ApiBaseClient.safeApiCall(ApiConstant.BLOG_SAVE, RequestType.post,
        queryParameters: saveEntity.toJson(),
        onLoading: () {},
        onSuccess: (res) {}, onError: (error) {
      ApiBaseClient.handleApiError(error);
      apiCallStatus = ApiCallStatus.error;
      update();
    });
  }

  @override
  void onClose() {
    // publishController.dispose();
    super.onClose();
  }
}
