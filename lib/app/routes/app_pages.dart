import 'package:get/get.dart';
import 'package:qqai/app/components/video_player_detail/FullScreenVideoPlayer.dart';
import 'package:qqai/app/pages/friends/friends_page.dart';
import 'package:qqai/app/pages/friends/user_detail_page.dart';
import 'package:qqai/app/pages/goods/goods_detail_page.dart';
import 'package:qqai/app/pages/goods/goods_page.dart';
import 'package:qqai/app/pages/index/bindings/home_binding.dart';
import 'package:qqai/app/pages/index/views/home_appbar_item_page.dart';
import 'package:qqai/app/pages/lookart/views/look_art_view.dart';
import 'package:qqai/app/pages/meleft/mycare_page.dart';
import 'package:qqai/app/pages/meleft/mycollect_page.dart';
import 'package:qqai/app/pages/tool/ai_page.dart';
import 'package:qqai/app/pages/tool/bindings/tool_binding.dart';
import 'package:qqai/app/pages/tool/calendar_tool_page.dart';
import 'package:qqai/app/pages/tool/date_tool_page.dart';
import 'package:qqai/app/pages/tool/id_tool_page.dart';
import 'package:qqai/app/pages/tool/ip_tool_page.dart';
import 'package:qqai/app/pages/tool/qr_code_page.dart';
import 'package:qqai/app/pages/tool/thumbnail_page.dart';
import 'package:qqai/app/pages/tool/url_tool_page.dart';
import 'package:qqai/app/pages/weather/views/perday_weather_view.dart';
import 'package:qqai/app/pages/weather/weather_home_page.dart';

import '../components/imgcomment/ImageDetailPage.dart';
import '../pages/fabu/bindings/fabu_zuopin_binding.dart';
import '../pages/fabu/views/fabu_goods_page.dart';
import '../pages/fabu/views/fabu_zuopin_page.dart';
import '../pages/index/views/home_page.dart';
import '../pages/lookart/bindings/loog_art_binding.dart';
import '../pages/search/search_page.dart';
import '../pages/watchvideo/play_video_page.dart';
import '../pages/weather/bindings/weather_binding.dart';
import '../pages/weather/weather_detail_view.dart';
import '../pages/weather/weather_left_page.dart';

part 'app_routes.dart';

// 中间件用于初始化禁用后退逻辑
class DisableBackMiddleware extends GetMiddleware {
  @override
  GetPage<dynamic>? onPageCalled(GetPage<dynamic>? page) {
    // Call JavaScript to disable back navigation
    // disableBackNavigation();
    // Return the page unchanged
    return page;
  }
}

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
      middlewares: [
        DisableBackMiddleware(),
      ],
    ),
    GetPage(
      name: Routes.watchImgUrl,
      page: () => ImageDetailPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.fullVideoUrl,
      page: () => FullScreenVideoPlayer(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: Routes.searchPage,
      page: () => SearchPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.aiPageUrl,
      page: () => AiPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.qrCodePageUrl,
      page: () => QrCodePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.calendarToolPageUrl,
      page: () => CalendarToolPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.care,
      page: () => MyCarePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.collect,
      page: () => MyCollectPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.dateToolPageUrl,
      page: () => DateToolPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.friendDetail,
      page: () => FriendsPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.goodsDetailPageUrl,
      page: () => GoodsDetailPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.goodsPageUrl,
      page: () => GoodsPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.idToolPageUrl,
      page: () => IdToolPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.urlToolPageUrl,
      page: () => UrlToolPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.homeAppbarItemPageUrl,
      page: () => HomeAppBarItemPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.userDetail,
      page: () => UserDetailPage(Get.parameters['userId'] as int,
          Get.parameters['showAppBar'] as bool),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.watchVideo,
      page: () => PlayVideoPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.whatArticle,
      page: () => LookartView(),
      binding: LoogArtBinding(),
    ),

    GetPage(
      name: Routes.ipToolPageUrl,
      page: () => IpToolPage(),
      binding: HomeBinding(),
    ),
    // GetPage(
    //   name: Routes.homeItemPageUrl,
    //   page: () => HomeItemPage(),
    //   binding: HomeBinding(),
    // ),
    GetPage(
      name: Routes.homeAppbarItemPageUrl,
      page: () => HomeAppBarItemPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.publishGoodsPageUrl,
      page: () => FabuGoodsPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.aiPageUrl,
      page: () => AiPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.thumbnailPageUrl,
      page: () => ThumbnailPage(),
      binding: ToolBing(),
    ),
    GetPage(
        name: Routes.publishZuoPinPageUrl,
        page: () => FabuZuoPinPage(),
        binding: FabuZuoPinBinding(),
        popGesture: false),
    GetPage(
      name: Routes.weatherPageUrl,
      page: () => WeatherHomePage(),
      binding: WeatherBinding(),
    ),
    GetPage(
        name: Routes.weatherLeftPageUrl,
        page: () => WeatherLeftPage(),
        binding: WeatherBinding(),
        popGesture: false),
    GetPage(
        name: Routes.weatherRightPageUrl,
        page: () => WeatherDetailView(),
        binding: WeatherBinding(),
        popGesture: false),
    GetPage(
        name: Routes.weatherRightPageUrl,
        page: () => PerDayWeatherView(),
        binding: WeatherBinding(),
        popGesture: false),
  ];
}
