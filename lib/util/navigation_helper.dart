import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 路由导航辅助类，用于替代 GetX 的导航方法
class NavigationHelper {
  /// 导航到指定路由（替代 Get.toNamed）
  static void toNamed(BuildContext context, String path, {Object? extra}) {
    context.push(path, extra: extra);
  }

  /// 替换当前路由（替代 Get.offNamed）
  static void offNamed(BuildContext context, String path, {Object? extra}) {
    context.go(path);
  }

  /// 返回上一页（替代 Get.back）
  static void back(BuildContext context, [Object? result]) {
    if (context.canPop()) {
      context.pop(result);
    } else {
      // 如果不能返回，可以关闭应用或导航到首页
      context.go('/');
    }
  }

  /// 导航到指定路由并清除所有历史（替代 Get.offAllNamed）
  static void offAllNamed(BuildContext context, String path, {Object? extra}) {
    context.go(path);
  }

  /// 获取路由参数（替代 Get.parameters）
  static Map<String, String> getParameters(BuildContext context) {
    final state = GoRouterState.of(context);
    return state.pathParameters;
  }

  /// 获取路由参数值（替代 Get.parameters['key']）
  static String? getParameter(BuildContext context, String key) {
    final state = GoRouterState.of(context);
    return state.pathParameters[key];
  }

  /// 获取路由参数（替代 Get.arguments）
  static T? getArguments<T>(BuildContext context) {
    final state = GoRouterState.of(context);
    return state.extra as T?;
  }
}

