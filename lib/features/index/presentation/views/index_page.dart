import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/features/index/data/home_tab_config.dart';
import 'package:qqai/features/index/presentation/widgets/app_bar_publish_search_actions.dart';
import 'package:qqai/features/index/presentation/widgets/brand_drawer_leading.dart';
import 'package:qqai/features/index/presentation/widgets/drawer_page.dart';
import 'package:qqai/features/index/presentation/widgets/app_bar_user_avatar.dart';
import 'package:qqai/features/index/providers/home_providers.dart';
import 'package:qqai/features/index/providers/home_index_tab_navigate_provider.dart';
import 'package:qqai/features/index/providers/main_shell_tab_reselect_provider.dart';

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
  }

  void _onTabChanged() {
    onLazyTabChanged(_tabController);
    if (!_tabController.indexIsChanging) {
      _activeHomeTabIndex = _tabController.index;
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

  Future<void> _refreshCurrentHomeTab() async {
    await homeTabConfigs[_tabController.index].onReselect?.call(ref);
  }

  Future<void> _refreshHomeTabAt(int index) async {
    await homeTabConfigs[index].onReselect?.call(ref);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(mainShellTabReselectProvider(0), (int? previous, int next) {
      if (!context.mounted) return;
      if (previous != null && next > previous) {
        _refreshCurrentHomeTab();
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
    });

    final isWideScreen = 1.sw > 800;
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
        centerTitle: false,
        titleSpacing: 0,
        title: animatedTitle(),
        actions: [animateActions()],
      ),
      drawer: isWideScreen ? null : const DrawerPage(),
      endDrawer: isWideScreen ? const DrawerPage() : null,
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
    return Align(
      alignment: Alignment.centerLeft,
      key: ValueKey('home_tab_bar_title_${_tabController.index}'),
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
    final isWideScreen = 1.sw > 800;
    return Row(
      key: ValueKey('home_actions_${_tabController.index}'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppBarPublishSearchActions(),
        if (isWideScreen) _avatarEndDrawerAction(),
      ],
    );
  }

  Widget _avatarEndDrawerAction() {
    return Builder(
      builder: (ctx) => AppBarUserAvatarButton(
        onPressed: () => Scaffold.of(ctx).openEndDrawer(),
      ),
    );
  }
}
