import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../components/AnimatedBottomBar.dart';
import '../../../../components/AnimatedLeftBar.dart';
import '../../providers/home_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    final bool isWideScreen = 1.sw > 800;

    return Scaffold(
      body: isWideScreen
          ? getWideScreen(homeState)
          : ref.read(homeProvider.notifier).getMainPage(),
      bottomNavigationBar: !isWideScreen
          ? SafeArea(
              child: AnimatedBottomBar(
                selectedBarIndex: homeState.selected,
                barItems: HomeNotifier.barItems,
                onBarTap: (index) {
                  homeNotifier.changeMainPage(index);
                },
                animationDuration: const Duration(milliseconds: 150),
                barStyle: BarStyle(fontSize: 15.0, iconSize: 20.0),
              ),
            )
          : null,
    );
  }

  Widget getWideScreen(HomeState homeState) {
    return Row(
      children: [
        Drawer(
          width: homeState.isExtended ? 200 : 70,
          backgroundColor: Theme.of(context).primaryColor,
          shape: BorderDirectional(),
          child: SafeArea(
            child: Animatedleftbar(
              selectedBarIndex: homeState.selected,
              barItems: HomeNotifier.barItems,
              onBarTap: (index) {
                ref.read(homeProvider.notifier).changeMainPage(index);
              },
              animationDuration: const Duration(milliseconds: 150),
              barStyle: BarStyle(fontSize: 15.0, iconSize: 20.0),
              isExtended: homeState.isExtended,
            ),
          ),
        ),
        Expanded(
          child: ref.read(homeProvider.notifier).getMainPage(),
        ),
      ],
    );
  }
}
