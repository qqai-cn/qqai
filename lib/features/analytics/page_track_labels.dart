import '../../router/app_routes.dart';

/// 页面埋点展示名：优先 route name，其次 path / path 前缀。
class PageTrackLabels {
  PageTrackLabels._();

  static const Map<String, String> _routeNames = {
    'login': '登录',
    'cart': '购物车',
    'checkout': '确认订单',
    'orderResult': '支付结果',
    'footprint': '足迹',
    'feedback': '问题反馈',
    'memberCenter': '会员中心',
    'memberCenterDetail': '会员中心详情',
    'douyinGroupBuy': '团购',
    'douyinAnchorCenter': '主播中心',
    'douyinMyOrders': '我的订单',
    'douyinMyAddresses': '收货地址',
    'douyinWatchHistory': '观看历史',
    'douyinAllFeatures': '全部功能',
    'myProfileEdit': '编辑资料',
    'homeIndex': '首页',
    'homeVideo': '视频',
    'homeMessage': '消息',
    'homeMe': '我的',
    'goodsList': '商品列表',
    'goodsDetail': '商品详情',
    'ai': 'AI 助手',
    'qrCode': '二维码工具',
    'calendarTool': '日历工具',
    'dateTool': '日期工具',
    'idTool': '身份证工具',
    'urlTool': '链接工具',
    'ipTool': 'IP 工具',
    'thumbnail': '缩略图工具',
    'imageFormatConvert': '图片格式转换',
    'imageCompressIntro': '图片压缩',
    'jsonFormatter': 'JSON 格式化',
    'imageDetail': '图片预览',
    'lookArt': '图文详情',
    'blogImgDetailView': '图文博客详情',
    'blogVideoDetailView': '视频博客详情',
    'videoDetailView': '视频详情',
    'squareBlogView': '广场',
    'collectionBlogList': '合集',
    'myCare': '我的关注',
    'myCollect': '我的收藏',
    'friends': '好友',
    'friendPendingIncoming': '新的朋友',
    'groupInvitations': '群聊邀请',
    'userDetail': '用户主页',
    'chat': '聊天',
    'chatVideoCall': '视频通话',
    'chatMessageSearch': '消息搜索',
    'chatSettings': '聊天设置',
    'publishZuopin': '发布作品',
    'publishDynamic': '发布动态',
    'publishVideo': '发布视频',
    'publishShortVideo': '发布短视频',
    'publishHelp': '发布求助',
    'search': '搜索',
    'weatherHome': '天气',
    'weatherLeft': '天气详情',
    'weatherDetail': '逐日天气',
    'perDayWeather': '单日天气',
  };

  static const Map<String, String> _paths = {
    Routes.HOME: '首页',
    Routes.login: '登录',
    Routes.videoPage: '视频',
    Routes.messagePage: '消息',
    Routes.mePage: '我的',
    Routes.cartPageUrl: '购物车',
    Routes.checkoutPageUrl: '确认订单',
    Routes.orderResultPageUrl: '支付结果',
    Routes.footprint: '足迹',
    Routes.feedback: '问题反馈',
    Routes.memberCenter: '会员中心',
    Routes.douyinGroupBuy: '团购',
    Routes.douyinAnchorCenter: '主播中心',
    Routes.douyinMyOrders: '我的订单',
    Routes.douyinMyAddresses: '收货地址',
    Routes.douyinWatchHistory: '观看历史',
    Routes.douyinAllFeatures: '全部功能',
    Routes.myProfileEdit: '编辑资料',
    Routes.goodsPageUrl: '商品列表',
    Routes.aiPageUrl: 'AI 助手',
    Routes.aiChatPageUrl: 'AI 对话',
    Routes.aiFriendDetailPageUrl: 'AI 好友',
    Routes.qrCodePageUrl: '二维码工具',
    Routes.calendarToolPageUrl: '日历工具',
    Routes.dateToolPageUrl: '日期工具',
    Routes.idToolPageUrl: '身份证工具',
    Routes.urlToolPageUrl: '链接工具',
    Routes.ipToolPageUrl: 'IP 工具',
    Routes.thumbnailPageUrl: '缩略图工具',
    Routes.imageFormatConvertPageUrl: '图片格式转换',
    Routes.imageCompressIntroPageUrl: '图片压缩',
    Routes.jsonFormatterPageUrl: 'JSON 格式化',
    Routes.watchImgUrl: '图片预览',
    Routes.whatArticle: '图文详情',
    Routes.blogImgDetailView: '图文博客详情',
    Routes.blogVideoDetailView: '视频博客详情',
    Routes.videoDetailView: '视频详情',
    Routes.squareBlogView: '广场',
    Routes.collectionBlogList: '合集',
    Routes.care: '我的关注',
    Routes.collect: '我的收藏',
    Routes.friendDetail: '好友',
    Routes.friendPendingIncoming: '新的朋友',
    Routes.groupInvitations: '群聊邀请',
    Routes.chat: '聊天',
    Routes.publishDynamicPageUrl: '发布动态',
    Routes.publishVideoPageUrl: '发布视频',
    Routes.publishZuoPinPageUrl: '发布作品',
    Routes.publishHelpPageUrl: '发布求助',
    Routes.publishShortVideoPageUrl: '发布短视频',
    Routes.searchPage: '搜索',
    Routes.weatherPageUrl: '天气',
    Routes.weatherLeftPageUrl: '天气详情',
    Routes.weatherRightPageUrl: '逐日天气',
  };

  static const List<MapEntry<String, String>> _pathPrefixes = [
    MapEntry(Routes.goodsDetailPageUrl, '商品详情'),
    MapEntry(Routes.memberCenterDetail, '会员中心详情'),
    MapEntry(Routes.userDetail, '用户主页'),
    MapEntry('${Routes.chat}/', '聊天'),
    MapEntry('${Routes.weatherPageUrl}/', '天气'),
  ];

  static String resolve({
    required String pagePath,
    String? routeName,
  }) {
    final normalizedPath = _normalizePath(pagePath);

    if (normalizedPath.startsWith('/home/tab/')) {
      final title = normalizedPath.substring('/home/tab/'.length);
      if (title.isNotEmpty) {
        return title;
      }
    }

    if (routeName != null && routeName.isNotEmpty) {
      final fromRoute = _routeNames[routeName];
      if (fromRoute != null) {
        return fromRoute;
      }
    }

    final exact = _paths[normalizedPath];
    if (exact != null) {
      return exact;
    }

    for (final entry in _pathPrefixes) {
      if (normalizedPath == entry.key || normalizedPath.startsWith('${entry.key}/')) {
        return entry.value;
      }
    }

    if (routeName != null && routeName.isNotEmpty) {
      return routeName;
    }

    return normalizedPath.isEmpty ? '首页' : normalizedPath;
  }

  static String _normalizePath(String pagePath) {
    final path = pagePath.split('?').first.trim();
    if (path.isEmpty || path == '/') {
      return Routes.HOME;
    }
    return path.endsWith('/') && path.length > 1
        ? path.substring(0, path.length - 1)
        : path;
  }
}
