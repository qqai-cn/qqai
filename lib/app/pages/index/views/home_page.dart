import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qqai/app/pages/index/controllers/home_controller.dart';
import 'package:qqai/app/pages/index/views/widgets/slide_transition_x.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/theme/light_theme_colors.dart';
import '../../../components/AnimatedBottomBar.dart';
import '../../../routes/app_pages.dart';
import '../../drawer_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 判断屏幕宽度以决定显示 FAB 还是底部导航栏
    final bool showLabel = 1.sw > 600;
    // 判断是否为大屏，决定是否显示标签
    final bool isWideScreen = 1.sw > 800;
    if (isWideScreen) {
      return Obx(() {
        return getWideScreen();
      });
    } else {
      return Obx(() {
        return getSmallScreen();
      });
    }
  }

  Widget getWideScreen() {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
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
        title: animatedTitle(),
        actions: [animateActions()],
      ),
      drawer: const DrawerPage(),
      body: Row(
        children: [
          // 左侧 NavigationRail
          NavigationRail(
            selectedIndex: controller.selected.value,
            onDestinationSelected: (int index) {
              controller.changeMainPage(index);
            },
            labelType: NavigationRailLabelType.selected,
            minWidth: 80,
            groupAlignment: -1.0,
            backgroundColor: LightThemeColors.primaryColor,
            selectedIconTheme: const IconThemeData(color: Colors.white),
            unselectedIconTheme: IconThemeData(color: Colors.grey[600]),
            // 自定义选中项样式
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, color: Colors.white),
                label: Text('首页'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.video_library_outlined),
                selectedIcon: Icon(Icons.video_library, color: Colors.white),
                label: Text('影视'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.message_outlined),
                selectedIcon: Icon(Icons.message, color: Colors.white),
                label: Text('消息'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person, color: Colors.white),
                label: Text('我的'),
              ),
            ],
            // 选中项背景颜色（Material 3 默认处理）
            indicatorColor: Colors.deepPurple,
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // 主内容区
          Expanded(
            child: controller.mainPageBuilders[controller.selected.value](),
          ),
        ],
      ),
    );
  }

  Widget animatedTitle() {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          var tween = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
          return SlideTransitionX(
            child: child,
            direction: AxisDirection.down, //上入下出
            position: animation,
          );
        },
        child: getTitleWidget());
  }

  Widget getTitleWidget() {
    if (controller.hasSearch.value || controller.selected.value == 3  ) {
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
    } else {
      return TabBar(
          controller: controller.tabController,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: controller.tabTitle.length > 2,
          tabs: controller.tabTitle.map((e) {
            return Container(
              height: 120.h,
              width: 100.w,
              alignment: Alignment.center,
              child: Text(e),
            );
          }).toList());
    }
  }

  Widget animateActions() {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          var tween = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
          return SlideTransitionX(
            child: child,
            direction: AxisDirection.down, //上入下出
            position: animation,
          );
        },
        child: controller.hasSearch.value
            ? Row(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.changeTab(1);
                    },
                    icon: Icon(Icons.switch_right),
                  ),
                  Container(
                    width: 100,
                    child: TextButton(
                      child: Text(
                        '京ICP备2022023998号-2',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      onPressed: () {
                        _launchURL(
                            Uri(scheme: 'https', host: 'beian.miit.gov.cn'));
                      },
                    ),
                  )
                ],
              )
            : Row(
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
              ));
  }

  Widget getSmallScreen() {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
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
          title: animatedTitle(),
          actions: [animateActions()],
        ),
        // --- 使用 Stack 作为 body ---
        body: controller.mainPageBuilders[controller.selected.value](),
        bottomNavigationBar: SafeArea(
          child: AnimatedBottomBar(
            barItems: controller.barItems,
            onBarTap: (index) {
              controller.changeMainPage(index);
            },
            animationDuration: const Duration(milliseconds: 150),
            barStyle: BarStyle(fontSize: 15.0, iconSize: 20.0),
          ),
        ) // 宽屏时隐藏
        );
  }

  Future<void> _launchURL(url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
