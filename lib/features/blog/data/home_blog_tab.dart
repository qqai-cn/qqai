/// 首页博客 Tab 下标，与 [HomeNotifier.tabItems] 一致。
abstract final class HomeBlogTab {
  static const int recommend = 0;
  static const int follow = 1;
  static const int local = 2;
}

/// 附近公开博客默认半径（千米），与接口默认一致。
const double blogNearbyRadiusKmDefault = 50;

/// 分享类型：公开
const int blogShareTypePublic = 1;
