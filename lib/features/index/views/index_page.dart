import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/KeepAliveTabWrapper.dart';
import '../../blog/presentation/views/blog_view.dart';
import '../../goods/goods_page.dart';
import '../../help/presentation/views/help_view.dart';
import '../../share/presentation/views/share_view.dart';
import '../../square/views/square_view.dart';
import '../../tool/tool_page.dart';

class IndexPage extends StatelessWidget {
  final TabController? tabController;
  
  const IndexPage({super.key, this.tabController});

  @override
  Widget build(BuildContext context) {
    // 如果 TabController 为 null，返回加载中的占位符
    if (tabController == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      body: Center(
          child: TabBarView(
        controller: tabController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          KeepAliveTabWrapper(child: BlogView(0)),
          KeepAliveTabWrapper(child: BlogView(1)),
          KeepAliveTabWrapper(child: BlogView(2)),
          KeepAliveTabWrapper(child: SquareView()),
          KeepAliveTabWrapper(child: GoodsPage()),
          KeepAliveTabWrapper(child: HelpView(6)),
          KeepAliveTabWrapper(child: ShareView(7)),
          KeepAliveTabWrapper(child: ToolPage())
        ],
      )),
    );
  }

  // Widget animatedTitle() {
  //   return AnimatedSwitcher(
  //     duration: Duration(milliseconds: 200),
  //     transitionBuilder: (Widget child, Animation<double> animation) {
  //       var tween = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
  //       return SlideTransitionX(
  //         child: child,
  //         direction: AxisDirection.down, //上入下出
  //         position: animation,
  //       );
  //     },
  //     child: controller.hasSearch.value
  //         ? InkWell(
  //             onTap: () {
  //               Get.toNamed(Routes.searchPage);
  //             },
  //             child: Container(
  //                 width: 0.8.sw,
  //                 height: 40,
  //                 margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
  //                 alignment: Alignment.centerLeft,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(15),
  //                   color: Colors.white,
  //                 ),
  //                 child: TextButton.icon(
  //                     onPressed: null,
  //                     icon: const Icon(Icons.search),
  //                     label: Text("英雄联盟手游"))),
  //           )
  //         : TabBar(
  //             controller: controller.tabController,
  //             indicatorSize: TabBarIndicatorSize.label,
  //             isScrollable: controller.tabTitle.length > 2 ? true : false,
  //             tabs: controller.tabTitle.map((e) {
  //               return Container(
  //                 height: 120.h,
  //                 width: 100.w,
  //                 alignment: Alignment.center,
  //                 child: Text(e),
  //               );
  //             }).toList()),
  //   );
  // }

  // Widget animateActions() {
  //   return AnimatedSwitcher(
  //       duration: Duration(milliseconds: 200),
  //       transitionBuilder: (Widget child, Animation<double> animation) {
  //         var tween = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
  //         return SlideTransitionX(
  //           child: child,
  //           direction: AxisDirection.down, //上入下出
  //           position: animation,
  //         );
  //       },
  //       child: controller.hasSearch.value
  //           ? Row(
  //               children: [
  //                 IconButton(
  //                   onPressed: () {
  //                     controller.changeTab(1);
  //                   },
  //                   icon: Icon(Icons.switch_right),
  //                 ),
  //                 Container(
  //                   width: 100,
  //                   child: TextButton(
  //                     child: Text(
  //                       '京ICP备2022023998号-2',
  //                       style: TextStyle(color: Colors.grey, fontSize: 10),
  //                     ),
  //                     onPressed: () {
  //                       _launchURL(
  //                           Uri(scheme: 'https', host: 'beian.miit.gov.cn'));
  //                     },
  //                   ),
  //                 )
  //               ],
  //             )
  //           : Row(
  //               children: [
  //                 IconButton(
  //                   icon: Icon(Icons.add_circle_sharp),
  //                   onPressed: () {
  //                     Get.toNamed(Routes.publishZuoPinPageUrl);
  //
  //                     // showModalBottomSheet(
  //                     //     constraints: BoxConstraints(maxHeight: 350.h),
  //                     //     context: context,
  //                     //     builder: (BuildContext build) {
  //                     //       return PublicSheets();
  //                     //     });
  //                   },
  //                 ),
  //                 IconButton(
  //                   icon: Icon(Icons.search),
  //                   onPressed: () {
  //                     Get.toNamed(Routes.searchPage);
  //                   },
  //                 )
  //               ],
  //             ));
  // }
  //
  // PreferredSizeWidget getAppbar1() {
  //   return AppBar(
  //     leading: Builder(
  //       builder: (context) {
  //         return GestureDetector(
  //           child: Image.asset(
  //             'imgs/hy.gif',
  //           ),
  //           onTap: () {
  //             Scaffold.of(context).openDrawer();
  //           },
  //         );
  //       },
  //     ),
  //     automaticallyImplyLeading: false,
  //     // centerTitle: false,
  //     title: animatedTitle(),
  //     actions: [animateActions()],
  //   );
  // }
  //
  // Future<void> _launchURL(url) async {
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
