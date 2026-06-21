import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

import '../../constant/api_constant.dart';
import '../../util/api_base_client.dart';
import '../../util/my_shared_pref.dart';
import 'page_track_labels.dart';
import 'page_track_navigator_observer.dart';

/// 页面访问埋点：GoRouter + 内嵌 Navigator + 手动补报。
class PageTrackService {
  PageTrackService._();

  static final PageTrackService instance = PageTrackService._();

  GoRouter? _router;
  VoidCallback? _delegateListener;
  VoidCallback? _routeInfoListener;
  String? _lastTrackedKey;
  bool _trackScheduled = false;

  late final PageTrackNavigatorObserver goodsTabNavigatorObserver =
      PageTrackNavigatorObserver(resolve: resolveGoodsTabRoute);

  void bindRouter(GoRouter router) {
    if (!identical(_router, router)) {
      _unbindRouter();
      _router = router;
      _delegateListener = () => scheduleTrackFromRouter();
      _routeInfoListener = () => scheduleTrackFromRouter();
      router.routerDelegate.addListener(_delegateListener!);
      router.routeInformationProvider.addListener(_routeInfoListener!);
      scheduleTrackFromRouter();
    }
  }

  void _unbindRouter() {
    final router = _router;
    if (router != null) {
      if (_delegateListener != null) {
        router.routerDelegate.removeListener(_delegateListener!);
      }
      if (_routeInfoListener != null) {
        router.routeInformationProvider.removeListener(_routeInfoListener!);
      }
    }
    _delegateListener = null;
    _routeInfoListener = null;
    _router = null;
  }

  /// GoRouter 变化后下一帧再读配置，避免 Shell / restore 时读到旧栈。
  void scheduleTrackFromRouter() {
    if (_trackScheduled) {
      return;
    }
    _trackScheduled = true;
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      _trackScheduled = false;
      final router = _router;
      if (router == null) {
        return;
      }
      _trackFromRouter(router);
    });
  }

  void _trackFromRouter(GoRouter router) {
    final config = router.routerDelegate.currentConfiguration;
    if (config.isEmpty) {
      return;
    }
    final uri = config.uri;
    final pagePath = _normalizePath(uri.path);
    final routeName = _leafRouteName(config);
    final pageName = PageTrackLabels.resolve(
      pagePath: pagePath,
      routeName: routeName,
    );
    trackPage(pagePath: pagePath, pageName: pageName);
  }

  /// 供 Shell Tab、首页子 Tab、内嵌 Navigator 等手动补报。
  void trackPage({
    required String pagePath,
    String? pageName,
  }) {
    final normalizedPath = _normalizePath(pagePath);
    final resolvedName = pageName?.trim().isNotEmpty == true
        ? pageName!.trim()
        : PageTrackLabels.resolve(pagePath: normalizedPath);
    final key = '$normalizedPath|$resolvedName';
    if (key == _lastTrackedKey) {
      return;
    }
    _lastTrackedKey = key;
    unawaited(_report(pagePath: normalizedPath, pageName: resolvedName));
  }

  Future<void> reportPageView({
    required String pagePath,
    String? pageName,
  }) async {
    trackPage(pagePath: pagePath, pageName: pageName);
  }

  Future<void> _report({
    required String pagePath,
    required String pageName,
  }) async {
    if (kDebugMode) {
      debugPrint('[PageTrack] $pagePath → $pageName');
    }
    try {
      await ApiBaseClient.safeApiCall(
        ApiConstant.INFRA_PAGE_TRACK_REPORT,
        RequestType.post,
        data: {
          'pagePath': pagePath,
          'pageName': pageName,
          'visitorId': await MySharedPref.getOrCreateVisitorId(),
          'platform': _platformLabel(),
        },
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[PageTrack] report failed: $pagePath ($error)');
      }
    }
  }

  String? _leafRouteName(RouteMatchList config) {
    if (config.matches.isEmpty) {
      return null;
    }

    RouteMatch? leaf;
    void walk(RouteMatchBase match) {
      if (match is ShellRouteMatch) {
        for (final child in match.matches) {
          walk(child);
        }
        return;
      }
      if (match is RouteMatch) {
        leaf = match;
      }
    }

    for (final match in config.matches) {
      walk(match);
    }
    return leaf?.route.name;
  }

  String _normalizePath(String pagePath) {
    final path = pagePath.split('?').first.trim();
    if (path.isEmpty || path == '/') {
      return '/';
    }
    return path.endsWith('/') && path.length > 1
        ? path.substring(0, path.length - 1)
        : path;
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
