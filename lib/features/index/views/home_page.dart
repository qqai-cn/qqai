import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/theme/light_theme_colors.dart';
import '../presentation/providers/home_providers.dart';
import '../presentation/providers/index_providers.dart';
import '../../../components/AnimatedBottomBar.dart';
import '../../../router/app_routes.dart';
import '../../drawer_page.dart';
import 'message_page.dart';
import 'widgets/slide_transition_x.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // 使用 postFrameCallback 延迟初始化，避免在 initState 中修改 provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initTabController();
      }
    });
  }

  void _initTabController() {
    final homeState = ref.read(homeProvider);
    final titles = ref.read(homeProvider.notifier).getTabviewMenu(homeState.selected);
    _tabController?.dispose();
    _tabController = TabController(
      length: titles.length,
      vsync: this,
      initialIndex: 0,
    )..addListener(_handleTabChange);
    // 使用 Future.microtask 延迟修改 provider，避免在 widget 构建过程中修改
    Future.microtask(() {
      if (mounted) {
        ref.read(homeProvider.notifier).updateTabTitle(homeState.selected);
      }
    });
    // 通知重建，确保 TabController 可用
    if (mounted) {
      setState(() {});
    }
  }

  void _handleTabChange() {
    if (_tabController != null && mounted) {
      // 使用 Future.microtask 延迟修改 provider，避免在 listener 回调中直接修改
      Future.microtask(() {
        if (mounted) {
          final homeState = ref.read(homeProvider);
          ref.read(homeProvider.notifier).handleTabChange(homeState.selected, _tabController!.index);
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    
    // 当 selected 改变时，重新初始化 TabController
    ref.listen(homeProvider.select((state) => state.selected), (previous, next) {
      if (previous != next && mounted) {
        // 使用 Future.microtask 延迟执行，避免在 build 过程中修改 provider
        Future.microtask(() {
          if (mounted) {
            _initTabController();
          }
        });
      }
    });
    
    // 如果 TabController 还未初始化，显示加载中
    if (_tabController == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 判断是否为大屏，决定是否显示标签
    final bool isWideScreen = 1.sw > 800;
    if (isWideScreen) {
      return getWideScreen(homeState);
    } else {
      return getSmallScreen(homeState);
    }
  }

  Widget getWideScreen(HomeState homeState) {
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
        title: animatedTitle(homeState),
        actions: [animateActions(homeState)],
      ),
      drawer: const DrawerPage(),
      body: Row(
        children: [
          // 左侧 NavigationRail
          NavigationRail(
            selectedIndex: homeState.selected,
            onDestinationSelected: (int index) {
              ref.read(homeProvider.notifier).changeMainPage(index);
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
            child: ref.read(homeProvider.notifier).mainPageBuilders[homeState.selected](_tabController),
          ),
        ],
      ),
    );
  }

  Widget animatedTitle(HomeState homeState) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          var tween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
          return SlideTransitionX(
            child: child,
            direction: AxisDirection.down, //上入下出
            position: animation,
          );
        },
        child: getTitleWidget(homeState));
  }

  Widget getTitleWidget(HomeState homeState) {
    if (homeState.hasSearch || homeState.selected == 3) {
      return InkWell(
        onTap: () {
          context.push(Routes.searchPage);
        },
        child: Container(
            width: 0.5.sw,
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
                label: const Text("英雄联盟手游"))),
      );
    } else {
      return TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: homeState.tabTitle.length > 2,
          tabs: homeState.tabTitle.map((e) {
            return Container(
              height: 120.h,
              width: 100.w,
              alignment: Alignment.center,
              child: Text(e),
            );
          }).toList());
    }
  }

  Widget animateActions(HomeState homeState) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          var tween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
          return SlideTransitionX(
            child: child,
            direction: AxisDirection.down, //上入下出
            position: animation,
          );
        },
        child: homeState.hasSearch
            ? Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_tabController != null && _tabController!.length > 1) {
                        _tabController!.animateTo(1);
                      }
                    },
                    icon: const Icon(Icons.switch_right),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextButton(
                      child: const Text(
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
              ));
  }

  Widget getSmallScreen(HomeState homeState) {
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
          title: animatedTitle(homeState),
          actions: [animateActions(homeState)],
        ),
        // --- 使用 Stack 作为 body ---
        body: ref.read(homeProvider.notifier).mainPageBuilders[homeState.selected](_tabController),
        bottomNavigationBar: SafeArea(
          child: AnimatedBottomBar(
            barItems: ref.read(homeProvider.notifier).barItems,
            onBarTap: (index) {
              ref.read(homeProvider.notifier).changeMainPage(index);
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
