import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../router/app_routes.dart';
import '../../../my/views/my_view.dart';
import '../../providers/home_providers.dart';
import '../widgets/drawer_page.dart';
import '../../../me/me_detail_page.dart';
import '../../../me/presentation/providers/me_providers.dart';

class MePage extends ConsumerWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meState = ref.watch(meProvider);
    final isWideScreen = MediaQuery.sizeOf(context).width > 800;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: getAppbar2(context, ref, isWideScreen),
      drawer: isWideScreen ? null : const DrawerPage(),
      body: Center(child: MyView()),
    );
  }

  PreferredSizeWidget getAppbar2(
    BuildContext context,
    WidgetRef ref,
    bool isWideScreen,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          if (isWideScreen) {
            ref.read(homeProvider.notifier).changeExtended();
          } else {
            Scaffold.of(context).openDrawer();
          }
        },
        child: const Icon(Icons.menu, size: 28, color: Colors.white),
      ),
      automaticallyImplyLeading: false,
      // title: animatedTitle(context),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_circle_sharp, color: Colors.white),
          onPressed: () => context.push(Routes.publishZuoPinPageUrl),
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () => context.push(Routes.searchPage),
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
          label: const Text("英雄联盟手游"),
        ),
      ),
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
        ),
      ],
    );
  }
}
