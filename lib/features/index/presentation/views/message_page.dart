import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../router/app_routes.dart';
import '../../../friends/chat_page_list.dart';
import '../../../friends/friends_page.dart';
import '../../providers/home_providers.dart';

class MessagePage extends ConsumerStatefulWidget {
  const MessagePage({super.key});

  @override
  ConsumerState<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends ConsumerState<MessagePage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // MessagePage 有 2 个 tab
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //导航栏
      // appBar: getAppbar2(),
      // drawer: const DrawerPage(),
      body: Center(
          child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ChatPageList(),
          FriendsPage(),
        ],
      )),
    );
  }

  PreferredSizeWidget getAppbar2(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    
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
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
          tabs: [''].map((e) {
            return Container(
              height: 120.h,
              width: 100.w,
              alignment: Alignment.center,
              child: Text(e),
            );
          }).toList()),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            context.push(Routes.publishZuoPinPageUrl);
            // showModalBottomSheet(
            //     constraints: BoxConstraints(maxHeight: 350.h),
            //     context: context,
            //     builder: (BuildContext build) {
            //       return PublicSheets();
            //     });
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            context.push(Routes.searchPage);
          },
        )
      ],
    );
  }

  Widget animatedTitle(WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    
    return TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.label,
        isScrollable: true,
        tabs: [].map((e) {
          return Container(
            height: 120.h,
            width: 100.w,
            alignment: Alignment.center,
            child: Text(e),
          );
        }).toList());
  }

  Widget animateActions(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.add_circle_sharp),
          onPressed: () {
            context.push(Routes.publishZuoPinPageUrl);
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            context.push(Routes.searchPage);
          },
        )
      ],
    );
  }
}
