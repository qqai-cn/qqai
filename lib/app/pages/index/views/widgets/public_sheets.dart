import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qqai/app/routes/app_pages.dart';

import '../../../../components/mybutton.dart';

class PublicSheets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: 1.sw,
      height: 350.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyFlatButton(
            text: '发布动态',
            img: 'imgs/dongtai.png',
            textColor: Colors.black54,
            onPress: () => {
              Get.back(),
              Get.toNamed(Routes.publishDynamicPageUrl),
            },
          ),
          MyFlatButton(
            text: '发布短视频',
            img: 'imgs/fabu-shorts.png',
            textColor: Colors.black54,
            onPress: () => {
              Get.back(),
              Get.toNamed(Routes.publishShortVideoPageUrl),
            },
          ),
          MyFlatButton(
            text: '发布视频',
            img: 'imgs/fabu-video.png',
            textColor: Colors.black54,
            onPress: () => {
              Get.back(),
              Get.toNamed(Routes.publishVideoPageUrl),
            },
          ),
          MyFlatButton(
            text: '发布商品',
            img: 'imgs/fabu-shangpin.png',
            textColor: Colors.black54,
            onPress: () => {
              Get.back(),
              Get.toNamed(Routes.publishGoodsPageUrl),
            },
          ),
        ],
      ),
    ));
  }
}
