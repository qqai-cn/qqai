import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/KeepAliveTabWrapper.dart';
import 'package:qqai/features/index/presentation/widgets/brand_drawer_leading.dart';
import 'package:qqai/features/index/presentation/widgets/drawer_page.dart';
import 'package:qqai/features/blog/providers/blog_providers.dart';
import 'package:qqai/features/help/providers/help_providers.dart';
import 'package:qqai/features/index/providers/home_follow_feed_providers.dart';
import 'package:qqai/features/index/providers/home_providers.dart';
import 'package:qqai/features/index/providers/main_shell_tab_reselect_provider.dart';
import 'package:qqai/features/share/providers/share_providers.dart';
import 'package:qqai/features/square/providers/square_providers.dart';
import 'package:qqai/router/app_routes.dart';

import '../../../blog/views/blog_list_kind.dart';
import '../../../blog/views/blog_view.dart';
import '../../../goods/goods_tab_navigator.dart';
import '../../../goods/providers/goods_mall_tab_reselect_provider.dart';
import '../../../help/views/help_view.dart';
import '../../../share/views/share_view.dart';
import '../../../square/views/square_view.dart';
import '../../../tool/tool_page.dart';
import '../widgets/slide_transition_x.dart';

class IndexPage extends ConsumerStatefulWidget {
  const IndexPage({super.key});

  @override
  ConsumerState<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends ConsumerState<IndexPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  /// 已挂载内容的 Tab 索引；首屏只建 0 与相邻页，其余懒建以降低首帧与首包成本。
  final Set<int> _mountedTabIndices = {0};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _expandTabsAround(_tabController.index);
    });
  }

  /// 当前 Tab 与左右各一屏，便于横向滑动时下一页已就绪。
  void _expandTabsAround(int i) {
    if (!mounted) return;
    setState(() {
      _mountedTabIndices.addAll({i, if (i > 0) i - 1, if (i < 7) i + 1});
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging || !mounted) return;
    _expandTabsAround(_tabController.index);
    setState(() {});
  }

  void _onHomeTabTap(int index) {
    if (index == _tabController.index) {
      _refreshHomeTabAt(index);
    }
  }

  Future<void> _refreshRecommendTab() async {
    if (_tabController.index != 0) {
      _tabController.animateTo(0);
    }
    await ref.read(blogProvider(0).notifier).refresh();
  }

  Future<void> _refreshHomeTabAt(int index) async {
    switch (index) {
      case 0:
        await ref.read(blogProvider(0).notifier).refresh();
      case 1:
        await ref.read(homeFollowFeedProvider.notifier).refresh();
      case 2:
        await ref.read(blogProvider(2).notifier).refresh();
      case 3:
        await ref.read(squareProvider.notifier).refresh();
      case 4:
        bumpGoodsMallTabReselect(ref);
      case 5:
        await ref.read(helpProvider.notifier).refresh();
      case 6:
        await ref.read(shareProvider.notifier).refresh();
      default:
        break;
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
    ref.listen(mainShellTabReselectProvider(0), (int? previous, int next) {
      if (previous != null && next > previous) {
        _refreshRecommendTab();
      }
    });

    final isWideScreen = 1.sw > 800;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: isWideScreen ? 148 : 48,
        leading: BrandDrawerLeading(isWideScreen: isWideScreen),
        automaticallyImplyLeading: false,
        title: animatedTitle(),
        actions: [animateActions()],
      ),
      drawer: isWideScreen ? null : const DrawerPage(),
      endDrawer: isWideScreen ? const DrawerPage() : null,
      body: RepaintBoundary(
        child: TabBarView(
          controller: _tabController,
          physics: const ClampingScrollPhysics(),
          children: List.generate(8, _tabBody),
        ),
      ),
    );
  }

  Widget _tabBody(int index) {
    if (!_mountedTabIndices.contains(index)) {
      return const ColoredBox(color: Colors.black12, child: SizedBox.expand());
    }
    switch (index) {
      case 0:
        return const KeepAliveTabWrapper(child: BlogView(0));
      case 1:
        return const KeepAliveTabWrapper(
          child: BlogView(1, listKind: BlogListKind.followFeed),
        );
      case 2:
        return const KeepAliveTabWrapper(child: BlogView(2));
      case 3:
        return const SquareView();
      case 4:
        return const KeepAliveTabWrapper(child: GoodsTabNavigator());
      case 5:
        return const HelpView(6);
      case 6:
        return const ShareView(7);
      case 7:
        return ToolPage();
      default:
        return const SizedBox.shrink();
    }
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
      return InkWell(
        key: const ValueKey('home_search_title'),
        onTap: () => context.push(Routes.searchPage),
        child: Container(
          width: 0.5.sw,
          height: 40,
          margin: const EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: TextButton.icon(
            onPressed: null,
            icon: const Icon(Icons.search),
            label: const Text('网站flutter源码出售，有意联系QQ：807404400'),
          ),
        ),
      );
    }
    return TabBar(
      key: const ValueKey('home_tab_bar_title'),
      controller: _tabController,
      isScrollable: true,
      onTap: _onHomeTabTap,
      tabs: HomeNotifier.tabItems.map((m) => Tab(text: m)).toList(),
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
    if (_tabController.index == 0) {
      return Row(
        children: [
          IconButton(
            icon: const Icon(Icons.switch_right),
            onPressed: () {
              setState(() {
                _tabController.animateTo(1);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_sharp),
            onPressed: () => context.push(Routes.publishZuoPinPageUrl),
          ),
          if (isWideScreen) _avatarEndDrawerAction(),
        ],
      );
    } else {
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
          if (isWideScreen) _avatarEndDrawerAction(),
        ],
      );
    }
  }

  Widget _avatarEndDrawerAction() {
    return Builder(
      builder: (ctx) => IconButton(
        tooltip: '个人中心',
        onPressed: () => Scaffold.of(ctx).openEndDrawer(),
        icon: const CircleAvatar(
          radius: 14,
          backgroundImage: AssetImage('imgs/user_default.png'),
        ),
      ),
    );
  }
}
