import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/components/KeepAliveTabWrapper.dart';
import 'package:qqai/features/blog/data/home_blog_tab.dart';
import 'package:qqai/features/blog/providers/blog_providers.dart';
import 'package:qqai/features/blog/views/blog_list_kind.dart';
import 'package:qqai/features/blog/views/blog_view.dart';
import 'package:qqai/features/goods/goods_tab_navigator.dart';
import 'package:qqai/features/goods/providers/goods_mall_tab_reselect_provider.dart';
import 'package:qqai/features/index/providers/home_follow_feed_providers.dart';
import 'package:qqai/features/square/providers/square_providers.dart';
import 'package:qqai/features/square/views/square_view.dart';
import 'package:qqai/features/tool/tool_page.dart';

typedef HomeTabRefresh = Future<void> Function(WidgetRef ref);

class HomeTabConfig {
  const HomeTabConfig({
    required this.title,
    required this.builder,
    this.onReselect,
  });

  final String title;
  final WidgetBuilder builder;
  final HomeTabRefresh? onReselect;
}

final List<HomeTabConfig> homeTabConfigs = [
  HomeTabConfig(
    title: '推荐',
    builder: (_) =>
        const KeepAliveTabWrapper(child: BlogView(HomeBlogTab.recommend)),
    onReselect: (ref) =>
        ref.read(blogProvider(HomeBlogTab.recommend).notifier).refresh(),
  ),
  HomeTabConfig(
    title: '热点',
    builder: (_) => const KeepAliveTabWrapper(child: BlogView(HomeBlogTab.hot)),
    onReselect: (ref) =>
        ref.read(blogProvider(HomeBlogTab.hot).notifier).refresh(),
  ),
  HomeTabConfig(
    title: '关注',
    builder: (_) => const KeepAliveTabWrapper(
      child: BlogView(HomeBlogTab.follow, listKind: BlogListKind.followFeed),
    ),
    onReselect: (ref) => ref.read(homeFollowFeedProvider.notifier).refresh(),
  ),
  HomeTabConfig(
    title: '本地',
    builder: (_) =>
        const KeepAliveTabWrapper(child: BlogView(HomeBlogTab.local)),
    onReselect: (ref) =>
        ref.read(blogProvider(HomeBlogTab.local).notifier).refresh(),
  ),
  HomeTabConfig(
    title: '广场',
    builder: (_) => const SquareView(),
    onReselect: (ref) => ref.read(squareProvider.notifier).refresh(),
  ),
  HomeTabConfig(
    title: '商场',
    builder: (_) => const KeepAliveTabWrapper(child: GoodsTabNavigator()),
    onReselect: (ref) async => bumpGoodsMallTabReselect(ref),
  ),
  HomeTabConfig(
    title: '互助',
    builder: (_) =>
        const KeepAliveTabWrapper(child: BlogView(HomeBlogTab.mutualAid)),
    onReselect: (ref) =>
        ref.read(blogProvider(HomeBlogTab.mutualAid).notifier).refresh(),
  ),
  HomeTabConfig(title: '工具', builder: (_) => ToolPage()),
];

/// 首页顶栏「商场」Tab 下标（与 [homeTabConfigs] 顺序一致）
const int kHomeMallTabIndex = 5;
