import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../components/imgcomment/ImageDetailPage.dart';
import '../components/video_player_detail/FullScreenVideoPlayer.dart';
import '../../features/fabu/presentation/views/fabu_goods_page.dart';
import '../../features/fabu/presentation/views/fabu_zuopin_page.dart';
import '../../features/friends/friends_page.dart';
import '../../features/friends/user_detail_page.dart';
import '../../features/goods/goods_detail_page.dart';
import '../../features/goods/goods_page.dart';
import '../../features/index/views/home_appbar_item_page.dart';
import '../../features/index/views/home_page.dart' as home;
import '../../features/lookart/presentation/views/look_art_view.dart';
import '../../features/meleft/mycare_page.dart';
import '../../features/meleft/mycollect_page.dart';
import '../../features/search/search_page.dart';
import '../../features/tool/ai_page.dart';
import '../../features/tool/calendar_tool_page.dart';
import '../../features/tool/date_tool_page.dart';
import '../../features/tool/id_tool_page.dart';
import '../../features/tool/ip_tool_page.dart';
import '../../features/tool/qr_code_page.dart';
import '../../features/tool/thumbnail_page.dart';
import '../../features/tool/url_tool_page.dart';
import '../../features/watchvideo/play_video_page.dart';
import '../../features/weather/presentation/views/perday_weather_view.dart';
import '../../features/weather/presentation/views/weather_detail_view.dart';
import '../../features/weather/presentation/views/weather_home_page.dart';
import '../../features/weather/presentation/views/weather_left_page.dart';
import 'app_routes.dart';
import '../providers/auth_providers.dart';

part 'app_router.g.dart';

// GoRouter Provider - 与 Riverpod 集成
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
      initialLocation: Routes.HOME,
      // 路由重定向守卫
      redirect: (context, state) {
        // 在 redirect 中读取 authProvider，避免在 build 中 watch 导致循环依赖
        final authState = ref.read(authProvider);
        final isAuthenticated = authState.isAuthenticated;
        final path = state.uri.path;

        // 检查是否需要认证
        if (!isAuthenticated && _requiresAuth(path)) {
          // 如果未认证且访问需要认证的页面，重定向到登录页
          // 注意：如果还没有登录页，可以先重定向到首页
          // return Routes.LOGIN;
          return Routes.HOME; // 临时重定向到首页
        }

        // 如果已认证且访问登录页，重定向到首页
        // if (isAuthenticated && path == Routes.LOGIN) {
        //   return Routes.HOME;
        // }

        return null; // 允许访问
      },
      routes: [

        /// ========== 首页 ==========
        GoRoute(
            path: Routes.HOME,
            name: 'home',
            builder: (context, state) => const home.HomePage()),

        /// ========== 工具类页面 ==========
        GoRoute(
            path: Routes.aiPageUrl, name: 'ai', builder: (c, s) => AiPage()),
        GoRoute(
            path: Routes.qrCodePageUrl,
            name: 'qrCode',
            builder: (c, s) => QrCodePage()),
        GoRoute(
            path: Routes.calendarToolPageUrl,
            name: 'calendarTool',
            builder: (c, s) => CalendarToolPage()),
        GoRoute(
            path: Routes.dateToolPageUrl,
            name: 'dateTool',
            builder: (c, s) => DateToolPage()),
        GoRoute(
            path: Routes.idToolPageUrl,
            name: 'idTool',
            builder: (c, s) => IdToolPage()),
        GoRoute(
            path: Routes.urlToolPageUrl,
            name: 'urlTool',
            builder: (c, s) => UrlToolPage()),
        GoRoute(
            path: Routes.ipToolPageUrl,
            name: 'ipTool',
            builder: (c, s) => IpToolPage()),
        GoRoute(
            path: Routes.thumbnailPageUrl,
            name: 'thumbnail',
            builder: (c, s) => ThumbnailPage()),

        /// ========== 内容详情 ==========
        GoRoute(
            path: Routes.watchImgUrl,
            name: 'imageDetail',
            builder: (c, s) {
              // 从 extra 获取参数
              final imageItem = s.extra;
              return ImageDetailPage(imageItem: imageItem);
            }),
        GoRoute(
            path: Routes.fullVideoUrl,
            name: 'fullScreenVideo',
            builder: (c, s) {
              final videoItem = s.extra;
              return FullScreenVideoPlayer(videoItem: videoItem);
            }),
        GoRoute(
            path: Routes.watchVideo,
            name: 'playVideo',
            builder: (c, s) {
              final videoItem = s.extra;
              return PlayVideoPage(videoItem: videoItem);
            }),
        GoRoute(
            path: Routes.whatArticle,
            name: 'lookArt',
            builder: (c, s) {
              final blogItem = s.extra;
              return LookartView(blogItem: blogItem);
            }),

        /// ========== 商品 ==========
        GoRoute(
            path: Routes.goodsPageUrl,
            name: 'goods',
            builder: (c, s) => GoodsPage()),
        GoRoute(
          path: '${Routes.goodsDetailPageUrl}/:id',
          name: 'goodsDetail',
          builder: (c, s) {
            // final id = s.pathParameters['id'] ?? ''; // TODO: 使用 id 参数
            return GoodsDetailPage();
          },
        ),

        /// ========== 我的 ==========
        GoRoute(
            path: Routes.care,
            name: 'myCare',
            builder: (c, s) => MyCarePage()),
        GoRoute(
            path: Routes.collect,
            name: 'myCollect',
            builder: (c, s) => MyCollectPage()),

        /// ========== 社交 ==========
        GoRoute(
            path: Routes.friendDetail,
            name: 'friends',
            builder: (c, s) => FriendsPage()),
        GoRoute(
          path: '${Routes.userDetail}/:userId/:showAppBar',
          name: 'userDetail',
          builder: (context, state) {
            final userId =
                int.tryParse(state.pathParameters['userId'] ?? '0') ?? 0;
            final showAppBar = state.pathParameters['showAppBar'] == 'true';
            return UserDetailPage(userId, showAppBar);
          },
        ),
        GoRoute(
          path: '${Routes.chat}/:chatId',
          name: 'chat',
          builder: (context, state) {
            final chatId = state.pathParameters['chatId'] ?? '';
            // TODO: 需要实现 ChatWidget 页面，接收 chatId 参数
            return Scaffold(
              body: Center(child: Text('Chat page for: $chatId')),
            );
          },
        ),

        /// ========== 发布 ==========
        GoRoute(
            path: Routes.publishGoodsPageUrl,
            name: 'publishGoods',
            builder: (c, s) => FabuGoodsPage()),
        GoRoute(
            path: Routes.publishZuoPinPageUrl,
            name: 'publishZuopin',
            builder: (c, s) =>
            const FabuZuoPinPage()
        ),

        /// ========== 搜索 ==========
        GoRoute(
            path: Routes.searchPage,
            name: 'search',
            builder: (c, s) => SearchPage()),

        /// ========== 天气模块（嵌套路由）==========
        ShellRoute(
          builder: (context, state, child) => const WeatherHomePage(),
          routes: [
            GoRoute(
              path: Routes.weatherPageUrl,
              name: 'weatherHome',
              builder: (context, state) => Container(), // 空占位，实际内容在 Shell 中
            ),
            GoRoute(
              path: 'left',
              name: 'weatherLeft',
              builder: (context, state) => const WeatherLeftPage(),
            ),
            GoRoute(
              path: 'detail',
              name: 'weatherDetail',
              builder: (context, state) => const WeatherDetailView(),
            ),
            GoRoute(
                path: 'per-day',
                name: 'perDayWeather',
                builder: (context, state) => PerDayWeatherView()),
          ],
        ),


        /// ========== 其他 ==========
        GoRoute(
            path: Routes.homeAppbarItemPageUrl,
            name: 'homeItem',
            builder: (c, s) => HomeAppBarItemPage()),
      ],
      errorBuilder: (context, state) =>
          Scaffold(
            body: Center(child: Text('PageRoute not found: ${state.uri}')),
          ),
  );
}

// 辅助函数：检查路由是否需要认证
bool _requiresAuth(String path) {
  // 定义需要认证的路由路径
  const protectedPaths = [
    // '/profile',      // 个人资料页
    // '/settings',     // 设置页
    // '/publish',      // 发布页
    // 可以根据需要添加更多需要认证的路径
  ];

  return protectedPaths.any((protected) => path.startsWith(protected));
}

// 辅助函数：无过渡动画
Page<dynamic> _noTransition(Widget child) {
  return NoTransitionPage(child: child);
}

// 辅助函数：禁用返回
Page<dynamic> _noTransitionWithPopScope(Widget child, {required bool canPop}) {
  return NoTransitionPage(
    child: PopScope(
      canPop: false,
      child: child,
    ),
  );
}
