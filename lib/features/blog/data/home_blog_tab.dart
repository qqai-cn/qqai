/// 首页博客 Tab 下标，与 [HomeNotifier.tabItems] 一致。
abstract final class HomeBlogTab {
  static const int recommend = 0;
  static const int hot = 1;
  static const int follow = 2;
  static const int local = 3;

  /// 首页「互助」Tab 的 [blogProvider] 分类键（关注流走独立 Provider）。
  static const int mutualAid = 2;
}

/// 后端博客 categary：1 动态 / 2 视频 / 3 求助。
abstract final class BlogCategary {
  static const int dynamic = 1;
  static const int video = 2;
  static const int help = 3;
}

/// 附近公开博客默认半径（千米），与接口默认一致。
const double blogNearbyRadiusKmDefault = 50;

/// 分享类型：公开
const int blogShareTypePublic = 1;

/// 博客内容类型，与后端 [SkuuBlogPageReqVO.blogType] 一致。
abstract final class BlogContentType {
  static const int image = 1;
  static const int video = 2;
}
