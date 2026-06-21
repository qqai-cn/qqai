import 'package:flutter/widgets.dart';

import 'page_track_service.dart';

/// 内嵌 Navigator 路由变化时上报（GoRouter 感知不到）。
class PageTrackNavigatorObserver extends NavigatorObserver {
  PageTrackNavigatorObserver({
    required this.resolve,
  });

  /// 根据 [Route.settings] 解析 (pagePath, pageName)；返回 null 则不上报。
  final PageTrackRoute? Function(Route<dynamic> route) resolve;

  void _track(Route<dynamic>? route) {
    if (route == null) {
      return;
    }
    final resolved = resolve(route);
    if (resolved == null) {
      return;
    }
    PageTrackService.instance.trackPage(
      pagePath: resolved.pagePath,
      pageName: resolved.pageName,
    );
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _track(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _track(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _track(previousRoute);
  }
}

class PageTrackRoute {
  const PageTrackRoute({
    required this.pagePath,
    required this.pageName,
  });

  final String pagePath;
  final String pageName;
}

/// 商场 Tab 内嵌栈 → 与 GoRouter 全局路径对齐，便于后管统计。
PageTrackRoute? resolveGoodsTabRoute(Route<dynamic> route) {
  final name = route.settings.name;
  switch (name) {
    case '/':
    case null:
      return const PageTrackRoute(
        pagePath: '/goods_page',
        pageName: '商品列表',
      );
    case '/detail':
      final goodsId = route.settings.arguments?.toString().trim() ?? '';
      if (goodsId.isEmpty) {
        return const PageTrackRoute(
          pagePath: '/goods_detail_page',
          pageName: '商品详情',
        );
      }
      return PageTrackRoute(
        pagePath: '/goods_detail_page/$goodsId',
        pageName: '商品详情',
      );
    case '/cart':
      return const PageTrackRoute(
        pagePath: '/cart',
        pageName: '购物车',
      );
    case '/checkout':
      return const PageTrackRoute(
        pagePath: '/checkout',
        pageName: '确认订单',
      );
    case '/order_result':
      return const PageTrackRoute(
        pagePath: '/order_result',
        pageName: '支付结果',
      );
    default:
      return null;
  }
}

/// 首页顶栏子 Tab（推荐 / 热点 / 商场等），GoRouter 路径仍为 `/`。
PageTrackRoute homeIndexTabRoute(String tabTitle) {
  return PageTrackRoute(
    pagePath: '/home/tab/$tabTitle',
    pageName: tabTitle,
  );
}

/// GoRouter 根 Navigator 的 push/pop 兜底（与 delegate 监听互补）。
class PageTrackRootNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    PageTrackService.instance.scheduleTrackFromRouter();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    PageTrackService.instance.scheduleTrackFromRouter();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    PageTrackService.instance.scheduleTrackFromRouter();
  }
}

/// 底部主壳 Tab
const List<PageTrackRoute> mainShellTabRoutes = [
  PageTrackRoute(pagePath: '/', pageName: '首页'),
  PageTrackRoute(pagePath: '/video_page', pageName: '视频'),
  PageTrackRoute(pagePath: '/message_page', pageName: '消息'),
  PageTrackRoute(pagePath: '/me_page', pageName: '我的'),
];
