import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/analytics/page_track_navigator_observer.dart';
import 'package:qqai/features/analytics/page_track_service.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';
import 'package:qqai/features/index/data/home_tab_config.dart';
import 'package:qqai/features/index/presentation/widgets/app_bar_publish_search_actions.dart';
import 'package:qqai/features/index/presentation/widgets/brand_drawer_leading.dart';
import 'package:qqai/features/index/presentation/widgets/drawer_page.dart';
import 'package:qqai/features/index/providers/home_providers.dart';
import 'package:qqai/features/index/providers/home_index_tab_navigate_provider.dart';
import 'package:qqai/features/index/providers/main_shell_tab_reselect_provider.dart';
import 'package:qqai/router/app_routes.dart';

import '../widgets/lazy_tab_slot.dart';
import '../widgets/slide_transition_x.dart';

class IndexPage extends ConsumerStatefulWidget {
  const IndexPage({super.key});

  @override
  ConsumerState<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends ConsumerState<IndexPage>
    with TickerProviderStateMixin, LazyTabMountMixin {
  late TabController _tabController;
  int _activeHomeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: HomeNotifier.tabItems.length,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackHomeTab(_activeHomeTabIndex);
    });
  }

  void _trackHomeTab(int index) {
    if (index < 0 || index >= homeTabConfigs.length) {
      return;
    }
    final tab = homeIndexTabRoute(homeTabConfigs[index].title);
    PageTrackService.instance.trackPage(
      pagePath: tab.pagePath,
      pageName: tab.pageName,
    );
  }

  void _onTabChanged() {
    onLazyTabChanged(_tabController);
    if (!_tabController.indexIsChanging) {
      _activeHomeTabIndex = _tabController.index;
      _trackHomeTab(_activeHomeTabIndex);
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void _onHomeTabTap(int index) {
    lazyTabMount(index);
    if (index == _activeHomeTabIndex) {
      _refreshHomeTabAt(index);
    } else {
      _activeHomeTabIndex = index;
    }
  }

  Future<void> _refreshHomeTabAt(int index) async {
    await homeTabConfigs[index].onReselect?.call(ref);
  }

  void _resetToFirstHomeTab({required bool refresh}) {
    lazyTabMount(0);
    if (_tabController.index != 0) {
      _activeHomeTabIndex = 0;
      _tabController.animateTo(0);
    }
    if (refresh) {
      Future.microtask(() => _refreshHomeTabAt(0));
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(mainShellTabActivationProvider(0), (
      MainShellTabActivation? previous,
      next,
    ) {
      if (!context.mounted) return;
      if (previous != null && next.nonce > previous.nonce) {
        _resetToFirstHomeTab(refresh: next.refresh);
      }
    });

    ref.listen(homeIndexTabNavigateProvider, (
      HomeIndexTabNavRequest? previous,
      next,
    ) {
      if (!context.mounted) return;
      if (previous == null || next.nonce <= previous.nonce) return;
      final index = next.tabIndex.clamp(0, HomeNotifier.tabItems.length - 1);
      lazyTabMount(index);
      if (_tabController.index != index) {
        _tabController.animateTo(index);
      } else {
        _refreshHomeTabAt(index);
      }
      _trackHomeTab(index);
    });

    final isWideScreen = 1.sw > 800;
    final onRecommendTab = _tabController.index == 0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leadingWidth: isWideScreen ? 148 : 48,
        leading: BrandDrawerLeading(isWideScreen: isWideScreen),
        automaticallyImplyLeading: false,
        centerTitle: onRecommendTab,
        titleSpacing: onRecommendTab ? null : 0,
        title: animatedTitle(),
        actions: [animateActions()],
      ),
      drawer: isWideScreen ? null : const DrawerPage(),
      body: RepaintBoundary(
        child: TabBarView(
          controller: _tabController,
          physics: const ClampingScrollPhysics(),
          children: List.generate(HomeNotifier.tabItems.length, _tabBody),
        ),
      ),
    );
  }

  Widget _tabBody(int index) {
    return LazyTabSlot(
      isMounted: lazyTabMountedIndices.contains(index),
      builder: (_) => homeTabConfigs[index].builder(context),
    );
  }

  Widget animatedTitle() {
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
      child: getTitleWidget(),
    );
  }

  Widget getTitleWidget() {
    if (_tabController.index == 0) {
      return _RecommendSearchTitle(
        key: const ValueKey('home_search_title'),
        onTap: () => context.push(Routes.searchPage),
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      key: const ValueKey('home_tab_bar_title'),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelPadding: const EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.zero,
        onTap: _onHomeTabTap,
        tabs: HomeNotifier.tabItems.map((m) => Tab(text: m)).toList(),
      ),
    );
  }

  Widget animateActions() {
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
      child: getActions(),
    );
  }

  Widget getActions() {
    final onRecommendTab = _tabController.index == 0;
    return Row(
      key: ValueKey('home_actions_${_tabController.index}'),
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onRecommendTab)
          IconButton(
            tooltip: '切换频道',
            icon: Icon(
              Icons.switch_right,
              color: AppActionColors.foreground(context),
            ),
            onPressed: () {
              lazyTabMount(1);
              _tabController.animateTo(1);
            },
          ),
        AppBarPublishSearchActions(showSearch: !onRecommendTab),
      ],
    );
  }
}

/// 推荐 Tab 顶栏：可点击的搜索条（进入全站搜索页）。
class _RecommendSearchTitle extends StatelessWidget {
  const _RecommendSearchTitle({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: 0.55.sw,
            height: 40,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppActionColors.surface(context),
              border: Border.all(color: GoodsPageStyle.border(context)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 20,
                  color: AppActionColors.subtle(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '搜索内容、用户、商品 &flutter全平台网站源码，有意联系807404400',
                    style: TextStyle(
                      color: AppActionColors.subtle(context),
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
