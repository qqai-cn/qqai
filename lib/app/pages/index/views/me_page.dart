import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qqai/app/pages/index/controllers/me_controller.dart';

import '../../../../constant/color_constant.dart';
import '../../../routes/app_pages.dart';
import '../../drawer_page.dart';
import '../../me/me_detail_page.dart';

class MePage extends GetView<MeController> {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        //导航栏
        // appBar: getAppbar2(),
        // drawer: const DrawerPage(),
        body: Center(
          child: MeDetailPage(controller.name.value),
        ),
      );
    });
  }

  PreferredSizeWidget getAppbar2() {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            child: Image.asset(
              'imgs/hy.gif',
            ),
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      automaticallyImplyLeading: false,
      title: animatedTitle(),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.toNamed(Routes.publishZuoPinPageUrl);
          },
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Get.toNamed(Routes.searchPage);
          },
        ),
      ],
    );
  }

  Widget animatedTitle() {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.searchPage);
      },
      child: Container(
          width: 0.8.sw,
          height: 40,
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: TextButton.icon(
              onPressed: null,
              icon: const Icon(Icons.search),
              label: Text("英雄联盟手游"))),
    );
  }

  Widget animateActions() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.add_circle_sharp),
          onPressed: () {
            Get.toNamed(Routes.publishZuoPinPageUrl);
          },
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Get.toNamed(Routes.searchPage);
          },
        )
      ],
    );
  }
}
