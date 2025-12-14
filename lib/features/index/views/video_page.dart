import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/providers/home_providers.dart';
import '../../video/short_video_player/short_video_player/short_video_player.dart';
import '../../video/views/long_video_view.dart';

class VideoPage extends ConsumerWidget {
  final TabController? tabController;
  
  const VideoPage({super.key, this.tabController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tabController == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      //导航栏
      body: Center(
          child: TabBarView(
        controller: tabController,
        physics: const AlwaysScrollableScrollPhysics(), //禁止滑动
        children: const [
          LongVideoView(),
          ShortVideoPlayer(),
        ],
      )),
    );
  }

  // PreferredSizeWidget getAppbar2() {
  //   return AppBar(
  //     leading: Builder(
  //       builder: (BuildContext context) {
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
  //     title: TabBar(
  //         controller: controller.tabController,
  //         indicatorSize: TabBarIndicatorSize.label,
  //         isScrollable: controller.tabTitle.length > 2,
  //         tabs: controller.tabTitle.map((e) {
  //           return Container(
  //             height: 120.h,
  //             width: 100.w,
  //             alignment: Alignment.center,
  //             child: Text(e),
  //           );
  //         }).toList()),
  //     actions: [
  //       IconButton(
  //         icon: Icon(Icons.add),
  //         onPressed: () {
  //           Get.toNamed(Routes.publishZuoPinPageUrl);
  //         },
  //       ),
  //       IconButton(
  //         icon: Icon(Icons.search),
  //         onPressed: () {
  //           Get.toNamed(Routes.searchPage);
  //         },
  //       )
  //     ],
  //   );
  // }
  //
  // Widget animatedTitle() {
  //   return TabBar(
  //       controller: controller.tabController,
  //       indicatorSize: TabBarIndicatorSize.label,
  //       isScrollable: controller.tabTitle.length > 2 ? true : false,
  //       tabs: controller.tabTitle.map((e) {
  //         return Container(
  //           height: 120.h,
  //           width: 100.w,
  //           alignment: Alignment.center,
  //           child: Text(e),
  //         );
  //       }).toList());
  // }
  //
  // Widget animateActions() {
  //   return Row(
  //     children: [
  //       IconButton(
  //         icon: Icon(Icons.add_circle_sharp),
  //         onPressed: () {
  //           Get.toNamed(Routes.publishZuoPinPageUrl);
  //         },
  //       ),
  //       IconButton(
  //         icon: Icon(Icons.search),
  //         onPressed: () {
  //           Get.toNamed(Routes.searchPage);
  //         },
  //       )
  //     ],
  //   );
  // }
}
