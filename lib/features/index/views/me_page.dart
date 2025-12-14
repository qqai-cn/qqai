import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../router/app_routes.dart';
import '../../drawer_page.dart';
import '../../me/me_detail_page.dart';
import '../../me/presentation/providers/me_providers.dart';

class MePage extends ConsumerWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meState = ref.watch(meProvider);
    
    return Scaffold(
      //导航栏
      // appBar: getAppbar2(context),
      // drawer: const DrawerPage(),
      body: Center(
        child: MeDetailPage(meState.name),
      ),
    );
  }

  PreferredSizeWidget getAppbar2(BuildContext context) {
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
      title: animatedTitle(context),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            context.push(Routes.publishZuoPinPageUrl);
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            context.push(Routes.searchPage);
          },
        ),
      ],
    );
  }

  Widget animatedTitle(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(Routes.searchPage);
      },
      child: Container(
          width: 0.8.sw,
          height: 40,
          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: TextButton.icon(
              onPressed: null,
              icon: const Icon(Icons.search),
              label: const Text("英雄联盟手游"))),
    );
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
