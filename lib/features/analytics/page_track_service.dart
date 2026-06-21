import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../constant/api_constant.dart';
import '../../util/api_base_client.dart';
import '../../util/my_shared_pref.dart';
import 'page_track_labels.dart';

/// 页面访问埋点：路由变化时自动上报 PV，后端按 userId / visitorId 统计 UV。
class PageTrackService {
  PageTrackService._();

  static final PageTrackService instance = PageTrackService._();

  String? _lastTrackedPath;

  void bindRouter(GoRouter router) {
    router.routerDelegate.addListener(() => _onRouteChanged(router));
    _onRouteChanged(router);
  }

  void _onRouteChanged(GoRouter router) {
    final path = router.routerDelegate.currentConfiguration.uri.path;
    if (path.isEmpty || path == _lastTrackedPath) {
      return;
    }
    _lastTrackedPath = path;
    final routeName = _leafRouteName(router);
    final pageName = PageTrackLabels.resolve(
      pagePath: path,
      routeName: routeName,
    );
    unawaited(reportPageView(pagePath: path, pageName: pageName));
  }

  /// Shell / Tab 路由需取叶子 GoRoute，否则 name 为空。
  String? _leafRouteName(GoRouter router) {
    final matches = router.routerDelegate.currentConfiguration.matches;
    if (matches.isEmpty) {
      return null;
    }

    RouteMatchBase current = matches.last;
    while (current is ShellRouteMatch) {
      if (current.matches.isEmpty) {
        return null;
      }
      current = current.matches.last;
    }

    if (current is RouteMatch) {
      return current.route.name;
    }
    return null;
  }

  Future<void> reportPageView({
    required String pagePath,
    String? pageName,
  }) async {
    final resolvedName = pageName?.trim().isNotEmpty == true
        ? pageName!.trim()
        : PageTrackLabels.resolve(pagePath: pagePath);
    try {
      await ApiBaseClient.safeApiCall(
        ApiConstant.INFRA_PAGE_TRACK_REPORT,
        RequestType.post,
        data: {
          'pagePath': pagePath,
          'pageName': resolvedName,
          'visitorId': await MySharedPref.getOrCreateVisitorId(),
          'platform': _platformLabel(),
        },
      );
    } catch (_) {
      // 埋点失败不影响用户使用
    }
  }

  String _platformLabel() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.fuchsia:
        return 'fuchsia';
    }
  }
}
