import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/login_page.dart';
import '../../features/friends/friends_page.dart' deferred as friends;
import '../../features/lookart/presentation/views/look_art_view.dart'
    deferred as look_art;
import '../../features/meleft/mycare_page.dart' deferred as my_care;
import '../../features/meleft/mycollect_page.dart' deferred as my_collect;
import '../../features/watchvideo/play_video_page.dart' deferred as play_video;
import '../cache/deferred_widget.dart';
import '../components/imgpreview/preview_img.dart';
import '../features/blog/data/blog_route_extra.dart';
import '../features/friends/friends_detail_view.dart' deferred as friend_detail;
import '../features/goods/models/cart_line.dart';
import '../features/index/presentation/views/home_page.dart';
import '../features/index/presentation/views/index_page.dart';
import '../features/index/presentation/views/me_page.dart';
import '../features/index/presentation/views/message_page.dart';
import '../features/index/presentation/views/video_page.dart';
import '../features/index/presentation/widgets/lazy_shell_tab.dart';
import '../providers/auth_providers.dart';
import '../util/api_base_client.dart';
import 'app_routes.dart';
import 'deferred_route_pages.dart' deferred as route_pages;

part 'app_router.g.dart';

/// 认证变化时通知 GoRouter 重新执行 [redirect]，**不得**为此重建 [GoRouter]，
/// 否则新实例会回到 [Routes.HOME]，发布页等栈会丢失（例如 401 刷新失败后像「跳回首页」）。
final class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(this._ref) {
    _ref.listen(authProvider, (previous, next) => notifyListeners());
  }

  final Ref _ref;
}

// GoRouter Provider - 与 Riverpod 集成
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authRefresh = _AuthRefreshListenable(ref);
  ref.onDispose(authRefresh.dispose);

  return GoRouter(
    initialLocation: Routes.HOME,
    refreshListenable: authRefresh,
    // 路由重定向守卫
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuthenticated = authState.isAuthenticated;
      final path = state.uri.path;
      final requiresAuth = _requiresAuth(path);

      // 未登录：只有需要认证的页面才跳转登录
      if (!isAuthenticated && requiresAuth && path != Routes.login) {
        return Routes.login;
      }

      // 已登录：访问登录页则回首页
      if (isAuthenticated && path == Routes.login) {
        return Routes.HOME;
      }

      return null; // 允许访问
    },
    routes: [
      /// ========== 登录 ==========
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.cartPageUrl,
        name: 'cart',
        builder: (context, state) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.CartView(),
        ),
      ),
      GoRoute(
        path: Routes.checkoutPageUrl,
        name: 'checkout',
        builder: (context, state) {
          final extra = state.extra;
          final lines = extra is List<CartLine> ? extra : null;
          if (lines == null || lines.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: const Text('确认订单')),
              body: const Center(child: Text('没有待结算商品')),
            );
          }
          return AppDeferredWidget(
            libraryLoader: route_pages.loadLibrary,
            builder: () => route_pages.CheckoutView(lines: lines),
          );
        },
      ),
      GoRoute(
        path: Routes.orderResultPageUrl,
        name: 'orderResult',
        builder: (context, state) {
          final extra = state.extra;
          final orderId = extra is String ? extra : '';
          return AppDeferredWidget(
            libraryLoader: route_pages.loadLibrary,
            builder: () => route_pages.OrderResultView(orderId: orderId),
          );
        },
      ),

      /// ========== 抖音风「我的」扩展 ==========
      GoRoute(
        path: Routes.douyinGroupBuy,
        name: 'douyinGroupBuy',
        builder: (context, state) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.DouyinGroupBuyPage(),
        ),
      ),
      GoRoute(
        path: Routes.douyinAnchorCenter,
        name: 'douyinAnchorCenter',
        builder: (context, state) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.DouyinAnchorCenterPage(),
        ),
      ),
      GoRoute(
        path: Routes.douyinMyOrders,
        name: 'douyinMyOrders',
        builder: (context, state) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.DouyinMyOrdersPage(),
        ),
      ),
      GoRoute(
        path: Routes.douyinWatchHistory,
        name: 'douyinWatchHistory',
        builder: (context, state) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.DouyinWatchHistoryPage(),
        ),
      ),
      GoRoute(
        path: Routes.douyinAllFeatures,
        name: 'douyinAllFeatures',
        builder: (context, state) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.DouyinAllFeaturesPage(),
        ),
      ),
      GoRoute(
        path: Routes.myProfileEdit,
        name: 'myProfileEdit',
        builder: (context, state) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.MyProfileEditPage(),
        ),
      ),

      /// ========== 首页（四 Tab 各自路径，便于 GoRouter redirect 统一鉴权）==========
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomePage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.HOME,
                name: 'homeIndex',
                builder: (context, state) =>
                    const LazyShellTab(tabIndex: 0, child: IndexPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.videoPage,
                name: 'homeVideo',
                builder: (context, state) =>
                    const LazyShellTab(tabIndex: 1, child: VideoPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.messagePage,
                name: 'homeMessage',
                builder: (context, state) {
                  final conversationId = int.tryParse(
                    state.uri.queryParameters['conversationId'] ?? '',
                  );
                  return LazyShellTab(
                    tabIndex: 2,
                    child: MessagePage(initialConversationId: conversationId),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.mePage,
                name: 'homeMe',
                builder: (context, state) =>
                    const LazyShellTab(tabIndex: 3, child: MePage()),
              ),
            ],
          ),
        ],
      ),

      /// ========== 商品 ==========
      GoRoute(
        path: Routes.goodsPageUrl,
        name: 'goodsList',
        builder: (context, state) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => Scaffold(
            appBar: AppBar(title: const Text('商品')),
            body: route_pages.GoodsView(),
          ),
        ),
      ),
      GoRoute(
        path: '${Routes.goodsDetailPageUrl}/:goodsId',
        name: 'goodsDetail',
        builder: (context, state) {
          final id = state.pathParameters['goodsId'] ?? '';
          return AppDeferredWidget(
            libraryLoader: route_pages.loadLibrary,
            builder: () => route_pages.GoodsDetailView(goodsId: id),
          );
        },
      ),

      /// ========== 工具类页面 ==========
      GoRoute(
        path: Routes.aiPageUrl,
        name: 'ai',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.AiPage(),
        ),
      ),
      GoRoute(
        path: Routes.qrCodePageUrl,
        name: 'qrCode',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.QrCodeToolPage(),
        ),
      ),
      GoRoute(
        path: Routes.calendarToolPageUrl,
        name: 'calendarTool',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.CalendarToolPage(),
        ),
      ),
      GoRoute(
        path: Routes.dateToolPageUrl,
        name: 'dateTool',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.DateToolPage(),
        ),
      ),
      GoRoute(
        path: Routes.idToolPageUrl,
        name: 'idTool',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.IdToolPage(),
        ),
      ),
      GoRoute(
        path: Routes.urlToolPageUrl,
        name: 'urlTool',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.UrlToolPage(),
        ),
      ),
      GoRoute(
        path: Routes.ipToolPageUrl,
        name: 'ipTool',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.IpToolPage(),
        ),
      ),
      GoRoute(
        path: Routes.thumbnailPageUrl,
        name: 'thumbnail',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.ThumbnailPage(),
        ),
      ),
      GoRoute(
        path: Routes.imageFormatConvertPageUrl,
        name: 'imageFormatConvert',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.ImageFormatConvertPage(),
        ),
      ),
      GoRoute(
        path: Routes.imageCompressIntroPageUrl,
        name: 'imageCompressIntro',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.ImageCompressIntroPage(),
        ),
      ),
      GoRoute(
        path: Routes.jsonFormatterPageUrl,
        name: 'jsonFormatter',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.JsonFormatterPage(),
        ),
      ),

      /// ========== 内容详情 ==========
      GoRoute(
        path: Routes.watchImgUrl,
        name: 'imageDetail',
        builder: (c, s) {
          final preview = s.extra as PreviewImg;
          return AppDeferredWidget(
            libraryLoader: route_pages.loadLibrary,
            builder: () => route_pages.ImageDetailPage(preview: preview),
          );
        },
      ),
      GoRoute(
        path: Routes.fullVideoUrl,
        name: 'fullScreenVideo',
        builder: (c, s) {
          final videoItem = s.extra;
          return AppDeferredWidget(
            libraryLoader: route_pages.loadLibrary,
            builder: () =>
                route_pages.FullScreenVideoPlayer(videoItem: videoItem),
          );
        },
      ),
      GoRoute(
        path: Routes.watchVideo,
        name: 'playVideo',
        builder: (c, s) {
          final videoItem = s.extra;
          return AppDeferredWidget(
            libraryLoader: play_video.loadLibrary,
            builder: () => play_video.PlayVideoPage(videoItem: videoItem),
          );
        },
      ),
      GoRoute(
        path: Routes.whatArticle,
        name: 'lookArt',
        builder: (c, s) {
          final blogItem = s.extra;
          return AppDeferredWidget(
            libraryLoader: look_art.loadLibrary,
            builder: () => look_art.LookartView(blogItem: blogItem),
          );
        },
      ),
      GoRoute(
        path: Routes.blogImgDetailView,
        name: 'blogImgDetailView',
        builder: (c, s) {
          final blogItem = parseBlogItemRouteExtra(s.extra);
          if (blogItem == null) {
            return const Scaffold(body: Center(child: Text('博客数据无效，请返回重试')));
          }
          return AppDeferredWidget(
            libraryLoader: route_pages.loadLibrary,
            builder: () => route_pages.BlogImgDetailView(blogItem: blogItem),
          );
        },
      ),
      GoRoute(
        path: Routes.blogVideoDetailView,
        name: 'blogVideoDetailView',
        builder: (c, s) {
          final blogItem = parseBlogItemRouteExtra(s.extra);
          if (blogItem == null) {
            return const Scaffold(body: Center(child: Text('博客数据无效，请返回重试')));
          }
          return AppDeferredWidget(
            libraryLoader: route_pages.loadLibrary,
            builder: () => route_pages.BlogVideoDetailView(blogItem: blogItem),
          );
        },
      ),
      GoRoute(
        path: Routes.videoDetailView,
        name: 'videoDetailView',
        builder: (c, s) {
          final blogItem = parseBlogItemRouteExtra(s.extra);
          if (blogItem == null) {
            return const Scaffold(body: Center(child: Text('博客数据无效，请返回重试')));
          }
          return AppDeferredWidget(
            libraryLoader: route_pages.loadLibrary,
            builder: () => route_pages.VideoDetailView(blogItem: blogItem),
          );
        },
      ),
      GoRoute(
        path: Routes.squareBlogView,
        name: 'squareBlogView',
        builder: (c, s) {
          final squareId = s.extra is int
              ? s.extra as int
              : int.tryParse(s.uri.queryParameters['id'] ?? '') ?? 0;
          return AppDeferredWidget(
            libraryLoader: route_pages.loadLibrary,
            builder: () => route_pages.SquareBlogView(squareId: squareId),
          );
        },
      ),

      /// ========== 商品 ==========
      /// ========== 我的 ==========
      GoRoute(
        path: Routes.care,
        name: 'myCare',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: my_care.loadLibrary,
          builder: () => my_care.MyCarePage(),
        ),
      ),
      GoRoute(
        path: Routes.collect,
        name: 'myCollect',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: my_collect.loadLibrary,
          builder: () => my_collect.MyCollectPage(),
        ),
      ),

      /// ========== 社交 ==========
      GoRoute(
        path: Routes.friendDetail,
        name: 'friends',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: friends.loadLibrary,
          builder: () => friends.FriendsPage(),
        ),
      ),
      GoRoute(
        path: Routes.friendPendingIncoming,
        name: 'friendPendingIncoming',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.FriendRequestsPage(),
        ),
      ),
      GoRoute(
        path: '${Routes.userDetail}/:userId/:showAppBar',
        name: 'userDetail',
        builder: (context, state) {
          final userId =
              int.tryParse(state.pathParameters['userId'] ?? '0') ?? 0;
          final showAppBar = state.pathParameters['showAppBar'] == 'true';
          return AppDeferredWidget(
            libraryLoader: friend_detail.loadLibrary,
            builder: () => friend_detail.FriendsDetailView(
              userId: userId,
              showAppBar: showAppBar,
            ),
          );
        },
      ),
      GoRoute(
        path: '${Routes.chat}/:chatId',
        name: 'chat',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['chatId'] ?? '') ?? 0;
          if (id == 0) {
            return Scaffold(
              appBar: AppBar(title: const Text('聊天')),
              body: const Center(child: Text('无效会话')),
            );
          }
          return AppDeferredWidget(
            libraryLoader: route_pages.loadLibrary,
            builder: () => Consumer(
              builder: (context, ref, _) {
                final auth = ref.watch(authProvider);
                return Scaffold(
                  appBar: AppBar(title: const Text('聊天')),
                  body: route_pages.ChatWidget(
                    key: ValueKey<int>(id),
                    currentUserId: auth.userId ?? '0',
                    conversationId: id,
                    initialMessages: const [],
                    dio: ApiBaseClient.dio,
                    token: auth.token,
                  ),
                );
              },
            ),
          );
        },
        routes: [
          GoRoute(
            path: 'settings',
            name: 'chatSettings',
            builder: (context, state) {
              final id =
                  int.tryParse(state.pathParameters['chatId'] ?? '') ?? 0;
              if (id == 0) {
                return Scaffold(
                  appBar: AppBar(title: const Text('聊天设置')),
                  body: const Center(child: Text('无效会话')),
                );
              }
              return AppDeferredWidget(
                libraryLoader: route_pages.loadLibrary,
                builder: () => route_pages.ChatConversationSettingsPage(
                  conversationId: id,
                ),
              );
            },
          ),
        ],
      ),

      /// ========== 发布 ==========
      GoRoute(
        path: Routes.publishZuoPinPageUrl,
        name: 'publishZuopin',
        builder: (c, s) {
          final squareId = int.tryParse(
            s.uri.queryParameters['squareId'] ?? '',
          );
          return AppDeferredWidget(
            libraryLoader: route_pages.loadLibrary,
            builder: () {
              final type = switch (s.uri.queryParameters['type']) {
                'video' => route_pages.FabuPublishType.video,
                'help' => route_pages.FabuPublishType.help,
                _ => route_pages.FabuPublishType.dynamic,
              };
              return route_pages.FabuView(
                squareId: squareId,
                initialType: type,
              );
            },
          );
        },
      ),
      GoRoute(
        path: Routes.publishDynamicPageUrl,
        name: 'publishDynamic',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.FabuView(
            initialType: route_pages.FabuPublishType.dynamic,
          ),
        ),
      ),
      GoRoute(
        path: Routes.publishVideoPageUrl,
        name: 'publishVideo',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.FabuView(
            initialType: route_pages.FabuPublishType.video,
          ),
        ),
      ),
      GoRoute(
        path: Routes.publishShortVideoPageUrl,
        name: 'publishShortVideo',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.FabuView(
            initialType: route_pages.FabuPublishType.video,
          ),
        ),
      ),
      GoRoute(
        path: Routes.publishHelpPageUrl,
        name: 'publishHelp',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.FabuView(
            initialType: route_pages.FabuPublishType.help,
          ),
        ),
      ),

      /// ========== 搜索 ==========
      GoRoute(
        path: Routes.searchPage,
        name: 'search',
        builder: (c, s) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.SearchPage(),
        ),
      ),

      /// ========== 天气模块（嵌套路由）==========
      ShellRoute(
        builder: (context, state, child) => AppDeferredWidget(
          libraryLoader: route_pages.loadLibrary,
          builder: () => route_pages.WeatherHomePage(),
        ),
        routes: [
          GoRoute(
            path: Routes.weatherPageUrl,
            name: 'weatherHome',
            builder: (context, state) => Container(),
          ),
          GoRoute(
            path: 'left',
            name: 'weatherLeft',
            builder: (context, state) => AppDeferredWidget(
              libraryLoader: route_pages.loadLibrary,
              builder: () => route_pages.WeatherLeftPage(),
            ),
          ),
          GoRoute(
            path: 'detail',
            name: 'weatherDetail',
            builder: (context, state) => AppDeferredWidget(
              libraryLoader: route_pages.loadLibrary,
              builder: () => route_pages.WeatherDetailView(),
            ),
          ),
          GoRoute(
            path: 'per-day',
            name: 'perDayWeather',
            builder: (context, state) => AppDeferredWidget(
              libraryLoader: route_pages.loadLibrary,
              builder: () => route_pages.PerDayWeatherView(),
            ),
          ),
        ],
      ),

      /// ========== 其他 ==========
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('PageRoute not found: ${state.uri}')),
    ),
  );
}

// 辅助函数：检查路由是否需要认证
bool _requiresAuth(String path) {
  if (path.startsWith('/douyin/')) return true;
  // 定义需要认证的路由路径
  const protectedPaths = [
    Routes.mePage, // 我的页面
    Routes.messagePage, // 消息页面
    Routes.publishZuoPinPageUrl, // 发布页面
    Routes.publishDynamicPageUrl,
    Routes.publishVideoPageUrl,
    Routes.publishShortVideoPageUrl,
    Routes.publishHelpPageUrl,
    Routes.myProfileEdit,
  ];
  return protectedPaths.any((protected) => path.startsWith(protected));
}
