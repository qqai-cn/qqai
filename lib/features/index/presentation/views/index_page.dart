import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/KeepAliveTabWrapper.dart';
import 'package:qqai/features/goods/views/goods_view.dart';
import 'package:qqai/features/index/presentation/widgets/brand_drawer_leading.dart';
import 'package:qqai/features/index/presentation/widgets/drawer_page.dart';
import 'package:qqai/features/index/providers/home_providers.dart';
import 'package:qqai/router/app_routes.dart';

import '../../../blog/views/blog_view.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging && mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: RepaintBoundary(
        child: TabBarView(
          controller: _tabController,
          physics: const ClampingScrollPhysics(),
          children: [
            KeepAliveTabWrapper(child: BlogView(0)),
            KeepAliveTabWrapper(child: BlogView(1)),
            KeepAliveTabWrapper(child: BlogView(2)),
            KeepAliveTabWrapper(child: SquareView()),
            KeepAliveTabWrapper(child: GoodsView()),
            KeepAliveTabWrapper(child: HelpView(6)),
            KeepAliveTabWrapper(child: ShareView(7)),
            KeepAliveTabWrapper(child: ToolPage()),
          ],
        ),
      ),
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
    } else {
      return TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: HomeNotifier.tabItems.map((m) => Tab(text: m)).toList(),
      );
    }
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
        ],
      );
    }
  }
}
