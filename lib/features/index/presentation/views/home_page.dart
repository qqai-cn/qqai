import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/AnimatedBottomBar.dart';
import '../../../../components/AnimatedLeftBar.dart';
import '../../providers/home_providers.dart';
import '../../providers/main_shell_tab_reselect_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void _onMainTabTap(int index) {
    final shell = widget.navigationShell;
    if (shell.currentIndex == index) {
      ref.read(mainShellTabReselectProvider(index).notifier).bump();
    } else {
      shell.goBranch(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final bool isWideScreen = 1.sw > 800;
    final shell = widget.navigationShell;

    return Scaffold(
      body: isWideScreen
          ? getWideScreen(homeState, shell)
          : shell,
      bottomNavigationBar: !isWideScreen
          ? SafeArea(
              child: AnimatedBottomBar(
                selectedBarIndex: shell.currentIndex,
                barItems: HomeNotifier.barItems,
                onBarTap: _onMainTabTap,
                animationDuration: const Duration(milliseconds: 150),
                barStyle: BarStyle(fontSize: 15.0, iconSize: 20.0),
              ),
            )
          : null,
    );
  }

  Widget getWideScreen(HomeState homeState, StatefulNavigationShell shell) {
    return Row(
      children: [
        Drawer(
          width: homeState.isExtended ? 200 : 70,
          backgroundColor: Theme.of(context).primaryColor,
          shape: BorderDirectional(),
          child: SafeArea(
            child: Animatedleftbar(
              selectedBarIndex: shell.currentIndex,
              barItems: HomeNotifier.barItems,
              onBarTap: _onMainTabTap,
              animationDuration: const Duration(milliseconds: 150),
              barStyle: BarStyle(fontSize: 15.0, iconSize: 20.0),
              isExtended: homeState.isExtended,
            ),
          ),
        ),
        Expanded(child: shell),
      ],
    );
  }
}
