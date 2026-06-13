import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../router/app_routes.dart';
import 'models/cart_line.dart';
import 'providers/goods_mall_tab_reselect_provider.dart';
import 'theme/goods_page_style.dart';
import 'views/cart_view.dart';
import 'views/checkout_view.dart';
import 'views/goods_detail_view.dart';
import 'views/goods_view.dart';
import 'views/order_result_view.dart';

/// 商场 Tab 内子路由（不跳出首页 Tab 栏）
abstract final class GoodsTabRoutes {
  static const list = '/';
  static const detail = '/detail';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orderResult = '/order_result';
}

/// 商场 Tab 根：内嵌 Navigator，承载列表 / 详情 / 购物车 / 结算 / 结果
class GoodsTabNavigator extends ConsumerStatefulWidget {
  const GoodsTabNavigator({super.key});

  @override
  ConsumerState<GoodsTabNavigator> createState() => _GoodsTabNavigatorState();
}

class _GoodsTabNavigatorState extends ConsumerState<GoodsTabNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    ref.listen(goodsMallTabReselectProvider, (previous, next) {
      if (!context.mounted) return;
      if (previous == null || next <= previous) return;
      final nav = _navigatorKey.currentState;
      if (nav == null) return;
      nav.popUntil(
        (route) => route.settings.name == GoodsTabRoutes.list || route.isFirst,
      );
      bumpGoodsMallListRefreshSignal(ref);
    });

    return Navigator(
      key: _navigatorKey,
      initialRoute: GoodsTabRoutes.list,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  static Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case GoodsTabRoutes.detail:
        final goodsId = settings.arguments as String? ?? '';
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => GoodsDetailView(goodsId: goodsId),
        );
      case GoodsTabRoutes.cart:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const CartView(),
        );
      case GoodsTabRoutes.checkout:
        final lines = settings.arguments;
        if (lines is! List<CartLine> || lines.isEmpty) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const _CheckoutEmptyPage(),
          );
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => CheckoutView(lines: lines),
        );
      case GoodsTabRoutes.orderResult:
        final orderId = settings.arguments as String? ?? '';
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => OrderResultView(orderId: orderId),
        );
      case GoodsTabRoutes.list:
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const GoodsView(),
        );
    }
  }
}

class _CheckoutEmptyPage extends StatelessWidget {
  const _CheckoutEmptyPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GoodsPageStyle.pageBg(context),
      appBar: AppBar(
        title: const Text('确认订单'),
        backgroundColor: GoodsPageStyle.cardBg(context),
        foregroundColor: GoodsPageStyle.text(context),
      ),
      body: const Center(child: Text('没有待结算商品')),
    );
  }
}

extension GoodsTabNavigation on BuildContext {
  /// 商场 Tab 内嵌 Navigator；个人中心等入口经 GoRouter 打开时不在此栈内。
  bool get _inGoodsTabNavigator =>
      findAncestorWidgetOfExactType<GoodsTabNavigator>() != null;

  NavigatorState get _goodsTabNav => Navigator.of(this);

  void pushGoodsDetail(String goodsId) {
    _goodsTabNav.pushNamed(GoodsTabRoutes.detail, arguments: goodsId);
  }

  void pushGoodsCart() {
    _goodsTabNav.pushNamed(GoodsTabRoutes.cart);
  }

  void pushGoodsCheckout(List<CartLine> lines) {
    if (lines.isEmpty) return;
    if (!_inGoodsTabNavigator) {
      push(Routes.checkoutPageUrl, extra: lines);
      return;
    }
    _goodsTabNav.pushNamed(GoodsTabRoutes.checkout, arguments: lines);
  }

  void pushGoodsOrderResult(String orderId) {
    if (!_inGoodsTabNavigator) {
      pushReplacement(Routes.orderResultPageUrl, extra: orderId);
      return;
    }
    _goodsTabNav.pushReplacementNamed(
      GoodsTabRoutes.orderResult,
      arguments: orderId,
    );
  }

  /// 回到商场商品列表（保留 Tab 内栈底）
  void popGoodsToList() {
    _goodsTabNav.popUntil(
      (route) => route.settings.name == GoodsTabRoutes.list,
    );
  }

  /// 打开购物车并清掉列表之上的页面
  void openGoodsCartFromRoot() {
    if (!_inGoodsTabNavigator) {
      go(Routes.cartPageUrl);
      return;
    }
    _goodsTabNav.pushNamedAndRemoveUntil(
      GoodsTabRoutes.cart,
      (route) => route.settings.name == GoodsTabRoutes.list,
    );
  }
}
