class ApiConstant {
  static const String BASE_URL = 'https://qqai.cn';

  // static const String BASE_URL = 'http://localhost:58080';
  static const String DAY_HISTORY_NEWS_URL =
      '/app-api/blog/news/dayHistory/news';
  static const String DAYHOT_NEWS_URL = '/app-api/blog/news/dayHot/news';
  static const String API_ID = '/app-api/blog/tool/id';
  static const String getByGPS = '/app-api/blog/qqai-weather-city/getByGPS';
  static const String WEATHER_USER_CITY_LIST =
      '/app-api/blog/weather-user-city/detail-list';
  static const String BLOG_PAGE = '/app-api/blog/qqai/page';
  static const String BLOG_SAVE = '/app-api/blog/qqai/save';

  /// 博客点赞（POST）/ 取消点赞（DELETE）：`/app-api/blog/qqai/profile/blog/{blogId}/like`
  static String profileBlogLikePath(int blogId) =>
      '/app-api/blog/qqai/profile/blog/$blogId/like';

  static const String TOPIC_PAGE = '/app-api/blog/topic/page';
  static const String FILE_UPLOAD = '/app-api/infra/file/upload';

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
  static const String CHAT_CONVERSATION_LIST =
      '/app-api/infra/chat/conversation/list';
  static const String CHAT_CONVERSATION_GET =
      '/app-api/infra/chat/conversation/get';
  static const String CHAT_CONVERSATION_GROUP =
      '/app-api/infra/chat/conversation/group';

  /// 个人中心 / 我的（QQAI blog profile）
  static const String PROFILE_MY_SHOP = '/app-api/blog/qqai/profile/my/shop';
  static const String PROFILE_MY_SHOP_PRODUCTS =
      '/app-api/blog/qqai/profile/my/shop/products';
  static const String PROFILE_MY_SHOP_PRODUCTS_PAGE =
      '/app-api/blog/qqai/profile/my/shop/products/page';
  static const String PROFILE_MY_WORKS_PAGE =
      '/app-api/blog/qqai/profile/my/works/page';
  static const String PROFILE_MY_LIKES_PAGE =
      '/app-api/blog/qqai/profile/my/likes/page';
  static const String PROFILE_MY_COLLECTIONS_PAGE =
      '/app-api/blog/qqai/profile/my/collections/page';
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

  /// 记录分享（分享次数 +1）
  static String blogSharePath(int blogId) => '/app-api/blog/qqai/$blogId/share';

  /// 收藏 POST、取消收藏 DELETE：`/app-api/blog/qqai/{blogId}/favorite`
  static String blogFavoritePath(int blogId) =>
      '/app-api/blog/qqai/$blogId/favorite';

  /// 我的收藏分页
  static const String BLOG_MY_FAVORITES_PAGE =
      '/app-api/blog/qqai/my/favorites/page';
}
