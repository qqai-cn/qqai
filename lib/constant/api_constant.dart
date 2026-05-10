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
}
