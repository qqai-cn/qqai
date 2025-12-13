import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LookArtController extends GetxController
    with GetTickerProviderStateMixin {
  int contentLine = 4;
  RxBool hiddenRight = false.obs;
  RxInt selectItemIndex = 0.obs;
  RxBool allComment = true.obs;
  final text =
      '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。我真的很喜欢你这个让我看一眼就会笑的女孩子，只靠爱情是不可能在一起辈子的，白头偕老需要的很多，成为情侣可能只需要爱情，但成为家人需要是我们两个人厮守到老，不仅仅要靠爱情更多的是习惯与责任。想和你走到最后，我会口是心非但我想让你看透我的心，我生气也好冷战也罢，这只能证明我爱你，我会故意气气你会粘着你会和你吵架，但是不会轻易离开你，我会管着你但不想失去你。'
          .obs;

  final items = <String>[
    '热度',
    '正序',
    '倒序',
  ];
  final List<String> tabValues = [
    '实时',
    '相关推荐',
  ];

  RxBool ifInputing = false.obs;

  final searchController = TextEditingController();

  late TabController tabController;


  @override
  void onInit() {
    tabController = TabController(
      length: tabValues.length,
      vsync: this,
    );
    super.onInit();
  }

  void resetWindow() {
    if (1.sw < 900) {
      hiddenRight.value = false;
    } else {
      hiddenRight.value = true;
    }
  }

  void setSelectItemIndex(int index) {
    selectItemIndex.value = index;
  }

  String getSelectItemIndex() {
    return items[selectItemIndex.value];
  }

  void setIfInputing(bool ifInput) {
    ifInputing.value = ifInput;
  }

  void changeSelectRange() {
    allComment.value = !allComment.value;
  }
}
