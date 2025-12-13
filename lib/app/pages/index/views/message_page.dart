import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qqai/app/components/chat/chat_widget.dart';
import 'package:qqai/app/pages/index/controllers/message_controller.dart';

import '../../../routes/app_pages.dart';
import '../../friends/chat_page_list.dart';
import '../../friends/friends_page.dart';
import '../controllers/home_controller.dart';

class MessagePage extends GetView<MessageController> {
  MessagePage({super.key});

  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //导航栏
      // appBar: getAppbar2(),
      // drawer: const DrawerPage(),
      body: Center(
          child: TabBarView(
        controller: homeController.tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ChatPageList(),
          FriendsPage(),
        ],
      )),
    );
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
      // centerTitle: false,
      title: TabBar(
          controller: controller.tabController,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: controller.tabTitle.length > 2 ? true : false,
          tabs: controller.tabTitle.map((e) {
            return Container(
              height: 120.h,
              width: 100.w,
              alignment: Alignment.center,
              child: Text(e),
            );
          }).toList()),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.toNamed(Routes.publishZuoPinPageUrl);
            // showModalBottomSheet(
            //     constraints: BoxConstraints(maxHeight: 350.h),
            //     context: context,
            //     builder: (BuildContext build) {
            //       return PublicSheets();
            //     });
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

  Widget animatedTitle() {
    return TabBar(
        controller: controller.tabController,
        indicatorSize: TabBarIndicatorSize.label,
        isScrollable: controller.tabTitle.length > 2 ? true : false,
        tabs: controller.tabTitle.map((e) {
          return Container(
            height: 120.h,
            width: 100.w,
            alignment: Alignment.center,
            child: Text(e),
          );
        }).toList());
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
