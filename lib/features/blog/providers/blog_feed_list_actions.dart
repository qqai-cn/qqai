import 'package:flutter/widgets.dart';

import '../data/models/blog_page_model.dart';

/// 首页瀑布流（推荐 / 关注）卡片共用的操作入口。
abstract interface class BlogFeedListActions {
  void onCareTap(BlogItem blogItem);

  void onZanTap(BlogItem blogItem);

  void onCollectTap(BlogItem blogItem);

  void onShareTap(BlogItem blogItem);

  void onBlogItemTap(BuildContext context, BlogItem blogItem);

  void onBlogImgItemTap(
    BuildContext context,
    BlogItem blogItem,
    int index,
    String heroTag,
    List<String> imageUrls,
  );

  double getVideoItemHeightWithWidth(int colCount, double screenWidth);
}
