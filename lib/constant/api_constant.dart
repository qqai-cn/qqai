class ApiConstant {
  static const String BASE_URL = 'https://aabe.cn';

  /// Socket.IO（与 BASE_URL 同域，Nginx 反代 /socket.io/ 到 59092）
  static const String SOCKET_IO_URL = BASE_URL;

  // static const String BASE_URL = 'http://localhost:58080';
  // static const String SOCKET_IO_URL = 'http://localhost:59092';
  static const String DAY_HISTORY_NEWS_URL =
      '/app-api/blog/news/dayHistory/news';
  static const String DAYHOT_NEWS_URL = '/app-api/blog/news/dayHot/news';
  static const String API_ID = '/app-api/blog/tool/id';
  static const String getByGPS = '/app-api/blog/qqai-weather-city/getByGPS';
  static const String WEATHER_USER_CITY_LIST =
      '/app-api/blog/weather-user-city/detail-list';
  static const String BLOG_PAGE = '/app-api/blog/qqai/page';
  static const String BLOG_HOT_PAGE = '/app-api/blog/qqai/hot/page';
  static const String BLOG_BACKGROUND_MUSIC_PAGE =
      '/app-api/blog/qqai/background-music/page';
  static const String BLOG_SAVE = '/app-api/blog/qqai/save';

  /// 博客点赞（POST）/ 取消点赞（DELETE）：`/app-api/blog/qqai/profile/blog/{blogId}/like`
  static String profileBlogLikePath(int blogId) =>
      '/app-api/blog/qqai/profile/blog/$blogId/like';

  static const String TOPIC_PAGE = '/app-api/blog/topic/page';
  static const String FILE_UPLOAD = '/app-api/infra/file/upload';
  static const String VIDEO_AD_CURRENT = '/app-api/infra/video-ad/current';

  // Auth
  static const String LOGIN = '/app-api/member/auth/login';
  static const String REGISTER = '/app-api/member/auth/register';
  static const String REFRESH_TOKEN = '/app-api/member/auth/refresh-token';

  // 好友
  static const String FRIEND_REMARK = '/app-api/member/friend/remark';
  static const String FRIEND_PENDING_INCOMING =
      '/app-api/member/friend/pending-incoming';
  static const String FRIEND_PENDING_OUTGOING =
      '/app-api/member/friend/pending-outgoing';
  static const String FRIEND_LIST_GROUPED =
      '/app-api/member/friend/list-grouped';
  static const String FRIEND_APPLY = '/app-api/member/friend/apply';
  static const String FRIEND_ACCEPT = '/app-api/member/friend/accept';
  static const String FRIEND_REJECT = '/app-api/member/friend/reject';
  static const String FRIEND_DELETE = '/app-api/member/friend/delete';

  // Chat / 消息
  static const String CHAT_MESSAGE_SEND = '/app-api/infra/chat/message/send';
  static const String CHAT_MESSAGE_PAGE = '/app-api/infra/chat/message/page';
  static const String CHAT_MESSAGE_SEARCH =
      '/app-api/infra/chat/message/search';
  static const String CHAT_CONVERSATION_LIST =
      '/app-api/infra/chat/conversation/list';
  static const String CHAT_CONVERSATION_GET =
      '/app-api/infra/chat/conversation/get';
  static const String CHAT_CONVERSATION_SINGLE =
      '/app-api/infra/chat/conversation/single';
  static const String CHAT_CONVERSATION_GROUP =
      '/app-api/infra/chat/conversation/group';
  static const String CHAT_CONVERSATION_GROUP_UPDATE =
      '/app-api/infra/chat/conversation/group/update';
  static const String CHAT_CONVERSATION_MUTE =
      '/app-api/infra/chat/conversation/mute';
  static const String CHAT_CONVERSATION_PIN =
      '/app-api/infra/chat/conversation/pin';
  static const String CHAT_CONVERSATION_DELETE =
      '/app-api/infra/chat/conversation/delete';
  static const String CHAT_CONVERSATION_CLEAR_HISTORY =
      '/app-api/infra/chat/conversation/clear-history';
  static const String CHAT_CONVERSATION_READ =
      '/app-api/infra/chat/conversation/read';
  static const String CHAT_GROUP_MEMBER_LIST =
      '/app-api/member/chat/conversation/members';
  static const String CHAT_GROUP_INVITATION_PENDING_INCOMING =
      '/app-api/member/chat/group-invitation/pending-incoming';
  static const String CHAT_GROUP_INVITATION_PENDING_OUTGOING =
      '/app-api/member/chat/group-invitation/pending-outgoing';
  static const String CHAT_GROUP_INVITATION_ACCEPT =
      '/app-api/member/chat/group-invitation/accept';
  static const String CHAT_GROUP_INVITATION_REJECT =
      '/app-api/member/chat/group-invitation/reject';

  static const String MEMBER_USER_UPDATE = '/app-api/member/user/update';
  static const String MEMBER_USER_GET = '/app-api/member/user/get';
  static const String MEMBER_LEVEL_LIST = '/app-api/member/level/list';
  static const String MEMBER_SIGN_IN_CONFIG_LIST =
      '/app-api/member/sign-in/config/list';
  static const String MEMBER_SIGN_IN_SUMMARY =
      '/app-api/member/sign-in/record/get-summary';
  static const String MEMBER_SIGN_IN_CREATE =
      '/app-api/member/sign-in/record/create';
  static const String MEMBER_POINT_RECORD_PAGE =
      '/app-api/member/point/record/page';
  static const String MEMBER_EXPERIENCE_RECORD_PAGE =
      '/app-api/member/experience-record/page';
  static const String MEMBER_ADDRESS_LIST = '/app-api/member/address/list';
  static const String MEMBER_ADDRESS_CREATE = '/app-api/member/address/create';
  static const String MEMBER_ADDRESS_UPDATE = '/app-api/member/address/update';
  static const String MEMBER_ADDRESS_DELETE = '/app-api/member/address/delete';
  static const String MEMBER_FEEDBACK_CREATE =
      '/app-api/member/feedback/create';
  static const String INFRA_PAGE_TRACK_REPORT =
      '/app-api/infra/page-track/report';
  static const String SYSTEM_AREA_TREE = '/app-api/system/area/tree';

  /// 个人中心 / 我的（QQAI blog profile）
  static const String PROFILE_MY_PAGE = '/app-api/blog/qqai/profile/my/page';
  static String profileUserPagePath(int userId) =>
      '/app-api/blog/qqai/profile/user/$userId/page';
  static String profileUserWorksPagePath(int userId) =>
      '/app-api/blog/qqai/profile/user/$userId/works/page';
  static String profileUserCollectionsPagePath(int userId) =>
      '/app-api/blog/qqai/profile/user/$userId/collections/page';
  static String profileUserShopProductsPagePath(int userId) =>
      '/app-api/blog/qqai/profile/user/$userId/shop/products/page';
  static const String PROFILE_MY_SHOP = '/app-api/blog/qqai/profile/my/shop';
  static const String PROFILE_MY_SHOP_PRODUCTS =
      '/app-api/blog/qqai/profile/my/shop/products';
  static const String PROFILE_MY_SHOP_PRODUCTS_PAGE =
      '/app-api/blog/qqai/profile/my/shop/products/page';
  static const String PROFILE_MY_BLOG_MOUNTED_PRODUCTS_PAGE =
      '/app-api/blog/qqai/profile/my/blog-mounted-products/page';
  static const String MALL_PRODUCTS_PAGE = '/app-api/product/spu/page';
  static const String MALL_PRODUCT_MY_PAGE = '/app-api/product/spu/my/page';
  static String mallProductUserPagePath(int userId) =>
      '/app-api/product/spu/user/$userId/page';
  static const String MALL_PRODUCT_UPDATE_STATUS =
      '/app-api/product/spu/update-status';
  static const String MALL_PRODUCT_DETAIL = '/app-api/product/spu/get-detail';
  static const String PRODUCT_COMMENT_PAGE = '/app-api/product/comment/page';
  static String productBrowsePath(int spuId) =>
      '/app-api/product/spu/$spuId/browse';
  static const String MALL_BROWSE_HISTORY_PAGE =
      '/app-api/product/browse-history/page';
  static const String MALL_BROWSE_HISTORY_DELETE =
      '/app-api/product/browse-history/delete';
  static const String MALL_BROWSE_HISTORY_CLEAN =
      '/app-api/product/browse-history/clean';
  static const String MALL_PRODUCT_FAVORITE_CREATE =
      '/app-api/product/favorite/create';
  static const String MALL_PRODUCT_FAVORITE_DELETE =
      '/app-api/product/favorite/delete';
  static const String MALL_PRODUCT_FAVORITE_EXISTS =
      '/app-api/product/favorite/exits';
  static const String MALL_PRODUCT_FAVORITE_PAGE =
      '/app-api/product/favorite/page';

  /// 商城交易：购物车 / 订单
  static const String TRADE_CART_LIST = '/app-api/trade/cart/list';
  static const String TRADE_CART_ADD = '/app-api/trade/cart/add';
  static const String TRADE_CART_UPDATE_COUNT =
      '/app-api/trade/cart/update-count';
  static const String TRADE_CART_UPDATE_SELECTED =
      '/app-api/trade/cart/update-selected';
  static const String TRADE_CART_DELETE = '/app-api/trade/cart/delete';
  static const String TRADE_ORDER_PAGE = '/app-api/trade/order/page';
  static const String TRADE_ORDER_ITEM_CREATE_COMMENT =
      '/app-api/trade/order/item/create-comment';

  static const String BLOG_BROWSE_HISTORY_PAGE =
      '/app-api/blog/qqai/browse-history/page';
  static const String BLOG_BROWSE_HISTORY_DELETE =
      '/app-api/blog/qqai/browse-history/delete';
  static const String BLOG_BROWSE_HISTORY_CLEAN =
      '/app-api/blog/qqai/browse-history/clean';
  static String blogBrowsePath(int blogId) =>
      '/app-api/blog/qqai/$blogId/browse';
  static const String PROFILE_MY_WORKS_PAGE =
      '/app-api/blog/qqai/profile/my/works/page';
  static const String PROFILE_MY_LIKES_PAGE =
      '/app-api/blog/qqai/profile/my/likes/page';
  static const String PROFILE_MY_COLLECTIONS_PAGE =
      '/app-api/blog/qqai/profile/my/collections/page';
  static const String PROFILE_COLLECTIONS =
      '/app-api/blog/qqai/profile/collections';
  static String profileCollectionDetailPath(int id) =>
      '/app-api/blog/qqai/profile/collections/$id';
  static const String PROFILE_COLLECTIONS_ITEMS =
      '/app-api/blog/qqai/profile/collections/items';

  /// 关注会员 POST / 取消关注 DELETE：`/app-api/blog/qqai/profile/follows/{userId}`
  static String profileFollowsPath(int userId) =>
      '/app-api/blog/qqai/profile/follows/$userId';

  /// 当前用户是否已关注该会员（未登录为 false）
  static String profileUserFollowedByMePath(int userId) =>
      '/app-api/blog/qqai/profile/user/$userId/followed-by-me';

  /// 我的关注博客流（分页）
  static const String PROFILE_MY_FOLLOWS_FEED_PAGE =
      '/app-api/blog/qqai/profile/my/follows/feed/page';

  /// 我关注的会员分页
  static const String PROFILE_MY_FOLLOWS_MEMBERS_PAGE =
      '/app-api/blog/qqai/profile/my/follows/members/page';

  /// 我的粉丝分页
  static const String PROFILE_MY_FOLLOWERS_MEMBERS_PAGE =
      '/app-api/blog/qqai/profile/my/followers/members/page';

  /// 博客评论
  static const String BLOG_COMMENTS = '/app-api/blog/qqai/comments';
  static const String BLOG_COMMENTS_PAGE = '/app-api/blog/qqai/comments/page';
  static const String BLOG_COMMENTS_REPLIES_PAGE =
      '/app-api/blog/qqai/comments/replies/page';
  static const String BLOG_COMMENTS_COUNT = '/app-api/blog/qqai/comments/count';

  static String blogCommentPath(int id) => '/app-api/blog/qqai/comments/$id';

  static String blogCommentPinPath(int id) =>
      '/app-api/blog/qqai/comments/$id/pin';

  /// 评论点赞 POST / 取消点赞 DELETE
  static String blogCommentLikePath(int id) =>
      '/app-api/blog/qqai/comments/$id/like';

  /// 博客视频弹幕
  static const String BLOG_DANMAKU = '/app-api/blog/qqai/danmaku';
  static const String BLOG_DANMAKU_LIST = '/app-api/blog/qqai/danmaku/list';

  /// 记录分享（分享次数 +1）
  static String blogSharePath(int blogId) => '/app-api/blog/qqai/$blogId/share';

  /// 获取博客详情（公开内容）
  static String blogDetailPath(int blogId) => '/app-api/blog/qqai/$blogId';

  /// 删除自己的博客
  static String blogDeletePath(int blogId) => '/app-api/blog/qqai/$blogId';

  /// 收藏 POST、取消收藏 DELETE：`/app-api/blog/qqai/{blogId}/favorite`
  static String blogFavoritePath(int blogId) =>
      '/app-api/blog/qqai/$blogId/favorite';

  /// 我的收藏分页
  static const String BLOG_MY_FAVORITES_PAGE =
      '/app-api/blog/qqai/my/favorites/page';

  /// 不感兴趣 POST：`/app-api/blog/qqai/{blogId}/dislike`
  static String blogDislikePath(int blogId) =>
      '/app-api/blog/qqai/$blogId/dislike';

  /// 举报 POST：`/app-api/blog/qqai/{blogId}/report`
  static String blogReportPath(int blogId) =>
      '/app-api/blog/qqai/$blogId/report';

  /// 广场分页
  static const String SQUARE_PAGE = '/app-api/blog/qqai/square/page';

  /// 广场列表（全部）
  static const String SQUARE_LIST = '/app-api/blog/qqai/square/list';

  /// 创建广场（自动创建专属群聊）
  static const String SQUARE_CREATE = '/app-api/blog/qqai/square/create';

  /// 更新广场
  static const String SQUARE_UPDATE = '/app-api/blog/qqai/square/update';

  static String squareDetailPath(int id) => '/app-api/blog/qqai/square/$id';

  static String squareBlogsPagePath(int id) =>
      '/app-api/blog/qqai/square/$id/blogs/page';

  static String squareJoinConversationPath(int id) =>
      '/app-api/blog/qqai/square/$id/conversation/join';

  /// 关注 POST / 取消关注 DELETE：`/app-api/blog/qqai/square/{id}/follow`
  static String squareFollowPath(int id) =>
      '/app-api/blog/qqai/square/$id/follow';
}
