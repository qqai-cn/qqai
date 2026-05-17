import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/features/blog/views/blog_img_detail_view.dart';
import 'package:qqai/features/blog/views/blog_video_detail_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/login_page.dart';
import '../../features/friends/friends_page.dart' deferred as friends;
import '../../features/lookart/presentation/views/look_art_view.dart'
    deferred as look_art;
import '../../features/meleft/mycare_page.dart' deferred as my_care;
import '../../features/meleft/mycollect_page.dart' deferred as my_collect;
import '../../features/search/search_page.dart';
import '../../features/tool/ai_page.dart' hide ChatWidget;
import '../../features/tool/calendar_tool_page.dart';
import '../../features/tool/date_tool_page.dart';
import '../../features/tool/image_compress_intro_page.dart';
import '../../features/tool/image_format_convert_page.dart';
import '../../features/tool/id_tool_page.dart';
import '../../features/tool/ip_tool_page.dart';
import '../../features/tool/json_formatter_page.dart';
import '../../features/tool/thumbnail_page.dart';
import '../../features/tool/url_tool_page.dart';
import '../../features/watchvideo/play_video_page.dart' deferred as play_video;
import '../../features/weather/presentation/views/perday_weather_view.dart';
import '../../features/weather/presentation/views/weather_detail_view.dart';
import '../../features/weather/presentation/views/weather_home_page.dart';
import '../../features/weather/presentation/views/weather_left_page.dart';
import '../cache/deferred_widget.dart';
import '../components/chat/chat_widget.dart';
import '../components/imgpreview/image_detail_page.dart';
import '../components/imgpreview/preview_img.dart';
import '../components/video_player_detail/FullScreenVideoPlayer.dart';
import '../features/blog/data/models/blog_page_model.dart';
import '../features/fabu/views/fabu_view.dart';
import '../features/goods/models/cart_line.dart';
import '../features/goods/views/cart_view.dart';
import '../features/goods/views/checkout_view.dart';
import '../features/goods/views/goods_detail_view.dart';
import '../features/goods/views/order_result_view.dart';
import '../features/douyin/views/douyin_all_features_page.dart';
import '../features/douyin/views/douyin_anchor_center_page.dart';
import '../features/douyin/views/douyin_group_buy_page.dart';
import '../features/douyin/views/douyin_my_orders_page.dart';
import '../features/douyin/views/douyin_watch_history_page.dart';
import '../features/goods/views/goods_view.dart';
import '../providers/auth_providers.dart';
import '../util/api_base_client.dart';
import '../features/friends/friend_requests_page.dart';
import '../features/friends/friends_detail_view.dart' deferred as friend_detail;
import '../features/index/presentation/views/home_page.dart';
import '../features/index/presentation/views/index_page.dart';
import '../features/index/presentation/views/me_page.dart';
import '../features/index/presentation/views/message_page.dart';
import '../features/index/presentation/views/video_page.dart';
import '../features/square/views/square_blog_view.dart';
import '../features/tool/qr_code_tool_page.dart';
import '../features/video/views/video_detail_view.dart';
import 'app_routes.dart';

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
        builder: (context, state) => const CartView(),
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
          return CheckoutView(lines: lines);
        },
      ),
      GoRoute(
        path: Routes.orderResultPageUrl,
        name: 'orderResult',
        builder: (context, state) {
          final extra = state.extra;
          final orderId = extra is String ? extra : '';
          return OrderResultView(orderId: orderId);
        },
      ),

      /// ========== 抖音风「我的」扩展 ==========
      GoRoute(
        path: Routes.douyinGroupBuy,
        name: 'douyinGroupBuy',
        builder: (context, state) => const DouyinGroupBuyPage(),
      ),
      GoRoute(
        path: Routes.douyinAnchorCenter,
        name: 'douyinAnchorCenter',
        builder: (context, state) => const DouyinAnchorCenterPage(),
      ),
      GoRoute(
        path: Routes.douyinMyOrders,
        name: 'douyinMyOrders',
        builder: (context, state) => const DouyinMyOrdersPage(),
      ),
      GoRoute(
        path: Routes.douyinWatchHistory,
        name: 'douyinWatchHistory',
        builder: (context, state) => const DouyinWatchHistoryPage(),
      ),
      GoRoute(
        path: Routes.douyinAllFeatures,
        name: 'douyinAllFeatures',
        builder: (context, state) => const DouyinAllFeaturesPage(),
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
                builder: (context, state) => const IndexPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.videoPage,
                name: 'homeVideo',
                builder: (context, state) => const VideoPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.messagePage,
                name: 'homeMessage',
                builder: (context, state) => const MessagePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.mePage,
                name: 'homeMe',
                builder: (context, state) => const MePage(),
              ),
            ],
          ),
        ],
      ),

      /// ========== 商品 ==========
      GoRoute(
        path: Routes.goodsPageUrl,
        name: 'goodsList',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('商品')),
          body: const GoodsView(),
        ),
      ),
      GoRoute(
        path: '${Routes.goodsDetailPageUrl}/:goodsId',
        name: 'goodsDetail',
        builder: (context, state) {
          final id = state.pathParameters['goodsId'] ?? '';
          return GoodsDetailView(goodsId: id);
        },
      ),

      /// ========== 工具类页面 ==========
      GoRoute(path: Routes.aiPageUrl, name: 'ai', builder: (c, s) => AiPage()),
      GoRoute(
        path: Routes.qrCodePageUrl,
        name: 'qrCode',
        builder: (c, s) => QrCodeToolPage(),
      ),
      GoRoute(
        path: Routes.calendarToolPageUrl,
        name: 'calendarTool',
        builder: (c, s) => CalendarToolPage(),
      ),
      GoRoute(
        path: Routes.dateToolPageUrl,
        name: 'dateTool',
        builder: (c, s) => DateToolPage(),
      ),
      GoRoute(
        path: Routes.idToolPageUrl,
        name: 'idTool',
        builder: (c, s) => IdToolPage(),
      ),
      GoRoute(
        path: Routes.urlToolPageUrl,
        name: 'urlTool',
        builder: (c, s) => const UrlToolPage(),
      ),
      GoRoute(
        path: Routes.ipToolPageUrl,
        name: 'ipTool',
        builder: (c, s) => const IpToolPage(),
      ),
      GoRoute(
        path: Routes.thumbnailPageUrl,
        name: 'thumbnail',
        builder: (c, s) => ThumbnailPage(),
      ),
      GoRoute(
        path: Routes.imageFormatConvertPageUrl,
        name: 'imageFormatConvert',
        builder: (c, s) => const ImageFormatConvertPage(),
      ),
      GoRoute(
        path: Routes.imageCompressIntroPageUrl,
        name: 'imageCompressIntro',
        builder: (c, s) => const ImageCompressIntroPage(),
      ),
      GoRoute(
        path: Routes.jsonFormatterPageUrl,
        name: 'jsonFormatter',
        builder: (c, s) => const JsonFormatterPage(),
      ),

      /// ========== 内容详情 ==========
      GoRoute(
        path: Routes.watchImgUrl,
        name: 'imageDetail',
        builder: (c, s) {
          // 从 extra 获取参数
          final preview = s.extra as PreviewImg;
          return ImageDetailPage(preview: preview);
        },
      ),
      GoRoute(
        path: Routes.fullVideoUrl,
        name: 'fullScreenVideo',
        builder: (c, s) {
          final videoItem = s.extra;
          return FullScreenVideoPlayer(videoItem: videoItem);
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
          final blogItem = s.extra as BlogItem;
          return BlogImgDetailView(blogItem: blogItem);
        },
      ),
      GoRoute(
        path: Routes.blogVideoDetailView,
        name: 'blogVideoDetailView',
        builder: (c, s) {
          final blogItem = s.extra as BlogItem;
          return BlogVideoDetailView(blogItem: blogItem);
        },
      ),
      GoRoute(
        path: Routes.videoDetailView,
        name: 'videoDetailView',
        builder: (c, s) {
          final blogItem = s.extra as BlogItem;
          return VideoDetailView(blogItem: blogItem);
        },
      ),
      GoRoute(
        path: Routes.squareBlogView,
        name: 'squareBlogView',
        builder: (c, s) {
          final squareId = s.extra is int
              ? s.extra as int
              : int.tryParse(s.uri.queryParameters['id'] ?? '') ?? 0;
          return SquareBlogView(squareId: squareId);
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
        builder: (c, s) => const FriendRequestsPage(),
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
          return Consumer(
            builder: (context, ref, _) {
              final auth = ref.watch(authProvider);
              return Scaffold(
                appBar: AppBar(title: const Text('聊天')),
                body: ChatWidget(
                  key: ValueKey<int>(id),
                  currentUserId: auth.userId ?? '0',
                  conversationId: id,
                  initialMessages: const [],
                  dio: ApiBaseClient.dio,
                  token: auth.token,
                ),
              );
            },
          );
        },
      ),

      /// ========== 发布 ==========
      GoRoute(
        path: Routes.publishZuoPinPageUrl,
        name: 'publishZuopin',
        builder: (c, s) {
          final squareId = int.tryParse(s.uri.queryParameters['squareId'] ?? '');
          return FabuView(squareId: squareId);
        },
      ),

      /// ========== 搜索 ==========
      GoRoute(
        path: Routes.searchPage,
        name: 'search',
        builder: (c, s) => const SearchPage(),
      ),

      /// ========== 天气模块（嵌套路由）==========
      ShellRoute(
        builder: (context, state, child) => WeatherHomePage(),
        routes: [
          GoRoute(
            path: Routes.weatherPageUrl,
            name: 'weatherHome',
            builder: (context, state) => Container(), // 空占位，实际内容在 Shell 中
          ),
          GoRoute(
            path: 'left',
            name: 'weatherLeft',
            builder: (context, state) => WeatherLeftPage(),
          ),
          GoRoute(
            path: 'detail',
            name: 'weatherDetail',
            builder: (context, state) => WeatherDetailView(),
          ),
          GoRoute(
            path: 'per-day',
            name: 'perDayWeather',
            builder: (context, state) => PerDayWeatherView(),
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
    Routes.publishZuoPinPageUrl, // 消息页面
  ];
  return protectedPaths.any((protected) => path.startsWith(protected));
}
