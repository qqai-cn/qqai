import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/features/index/presentation/widgets/drawer_page.dart';

import '../../../../components/AnimatedBottomBar.dart';
import '../../../../components/AnimatedLeftBar.dart';
import '../../../../router/app_routes.dart';
import '../../providers/home_providers.dart';
import '../widgets/slide_transition_x.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    final bool isWideScreen = 1.sw > 800;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              child: Image.asset('imgs/hy.gif'),
              onTap: () {
                if (isWideScreen) {
                  homeNotifier.changeExtended();
                } else {
                  Scaffold.of(context).openDrawer();
                }
              },
            );
          },
        ),
        automaticallyImplyLeading: false,
        title: animatedTitle(homeState),
        actions: [animateActions(homeState)],
      ),
      drawer: isWideScreen ? null : DrawerPage(),
      body: isWideScreen ? getWideScreen(homeState) : getSmallScreen(homeState),
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
        // 主内容区
        Expanded(child: ref.read(homeProvider.notifier).getMainPage()),
      ],
    );
  }

  Widget animatedTitle(HomeState homeState) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        // var tween =
        //     Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
        return SlideTransitionX(
          direction: AxisDirection.down, //上入下出
          position: animation,
          child: child,
        );
      },
      child: getTitleWidget(homeState),
    );
  }

  Widget getTitleWidget(HomeState homeState) {
    return InkWell(
      onTap: () {
        context.push(Routes.searchPage);
      },
      child: Container(
        width: 0.5.sw,
        height: 40,
        margin: EdgeInsets.all(10.0),
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

  Widget animateActions(HomeState homeState) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        // var tween =
        // Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
        return SlideTransitionX(
          direction: AxisDirection.down, //上入下出
          position: animation,
          child: child,
        );
      },
      child: Row(
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
      ),
    );
  }

  Widget getSmallScreen(HomeState homeState) {
    return ref.read(homeProvider.notifier).getMainPage();
  }
}
