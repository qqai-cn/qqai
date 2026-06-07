import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../blog_page_parse.dart';
import '../home_blog_tab.dart';
import '../models/blog_model.dart';
import '../models/blog_save_req_vo.dart';
import 'package:qqai/features/goods/data/models/trade_models.dart';

final blogRepoProvider = Provider<IBlogRepo>((ref) => BlogRepo());

class BlogBackgroundMusicItem {
  const BlogBackgroundMusicItem({
    this.blogId,
    required this.musicUrl,
    required this.musicName,
    this.coverUrl,
    this.creatorName,
    this.durationText,
    this.favorite = false,
  });

  final int? blogId;
  final String musicUrl;
  final String musicName;
  final String? coverUrl;
  final String? creatorName;
  final String? durationText;
  final bool favorite;

  factory BlogBackgroundMusicItem.fromJson(Map<String, dynamic> json) {
    return BlogBackgroundMusicItem(
      blogId: (json['blogId'] as num?)?.toInt(),
      musicUrl: (json['musicUrl'] ?? '').toString(),
      musicName: (json['musicName'] ?? '视频原声').toString(),
      coverUrl: json['coverUrl'] as String?,
      creatorName: json['creatorName'] as String?,
      durationText: json['durationText'] as String?,
      favorite: json['favorite'] == true,
    );
  }
}

abstract class IBlogRepo {
  Future<List<BlogModel>> getAllBlogs();

  Future<BlogModel?> getBlogById(String id);

  Future<void> addBlog(BlogModel item);

  Future<void> updateBlog(BlogModel item);

  Future<void> deleteBlog(String id);

  Future<BlogPageModelData> getBlogPageModelData();

  Future<BlogPageModelData> getBlogPageModelDataWithPage(
    int page, {
    int pageSize = 10,
    int? blogType,
    int? categary,
    int? squareId,
    int? userId,
    int? shareType,
    double? latitude,
    double? longitude,
    double? radiusKm,
  });

  Future<BlogPageModelData> getHotBlogPageModelDataWithPage(
    int page, {
    int pageSize = 10,
    int? blogType,
    int? categary,
    int? squareId,
    int? userId,
    int? shareType,
  });

  Future<void> createBlog(BlogSaveReqVO req, {int? rewardAmount});

  Future<List<BlogBackgroundMusicItem>> searchBackgroundMusic({
    String? keyword,
    String tab = 'recommend',
    int pageNo = 1,
    int pageSize = 20,
  });

  /// 切换点赞，返回切换后是否已赞。
  Future<bool> toggleBlogLike(int blogId, {required bool currentlyLiked});

  /// 记录分享，返回是否成功。
  Future<bool> recordBlogShare(int blogId);

  /// 按编号获取公开博客详情。
  Future<BlogItem?> fetchBlogItemById(int blogId);

  /// 删除自己的博客。
  Future<bool> deleteMyBlog(int blogId);

  /// 收藏博客（POST）。
  Future<bool> favoriteBlog(int blogId);

  /// 取消收藏（DELETE）。
  Future<bool> unfavoriteBlog(int blogId);

  /// 切换收藏，返回切换后是否已收藏。
  Future<bool> toggleBlogFavorite(
    int blogId, {
    required bool currentlyCollected,
  });

  /// 我的收藏分页。
  Future<BlogPageModelData> getMyFavoritesPage(int page, {int pageSize = 10});

  /// 标记不感兴趣。
  Future<bool> markBlogNotInterested(int blogId);

  /// 举报博客。
  Future<bool> reportBlog(
    int blogId, {
    required int reason,
    String? description,
  });

  /// 记录博客浏览（足迹）。
  Future<void> recordBlogBrowse(int blogId);

  Future<BlogBrowseHistoryPageData> getBlogBrowseHistoryPage(
    int pageNo, {
    int pageSize = 20,
  });

  Future<void> deleteBlogBrowseHistoryIds(List<int> blogIds);

  Future<void> cleanBlogBrowseHistory();
}

class BlogRepo implements IBlogRepo {
  final List<BlogModel> _items = [];

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<BlogModel?> getBlogById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addBlog(BlogModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
  }

  @override
  Future<void> updateBlog(BlogModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> deleteBlog(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }

  @override
  Future<BlogPageModelData> getBlogPageModelData() async {
    return getBlogPageModelDataWithPage(1);
  }

  @override
  Future<BlogPageModelData> getBlogPageModelDataWithPage(
    int page, {
    int pageSize = 10,
    int? blogType,
    int? categary,
    int? squareId,
    int? userId,
    int? shareType,
    double? latitude,
    double? longitude,
    double? radiusKm,
  }) async {
    final query = <String, dynamic>{'pageNo': page, 'pageSize': pageSize};
    if (blogType != null) query['blogType'] = blogType;
    if (categary != null) query['categary'] = categary;
    if (squareId != null) query['squareId'] = squareId;
    if (userId != null) query['userId'] = userId;
    if (shareType != null) query['shareType'] = shareType;
    if (latitude != null && longitude != null) {
      query['latitude'] = latitude;
      query['longitude'] = longitude;
      query['radiusKm'] = radiusKm ?? blogNearbyRadiusKmDefault;
    }
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_PAGE,
      RequestType.get,
      queryParameters: query,
    );
    return parseBlogPageEnvelope(response.data);
  }

  @override
  Future<BlogPageModelData> getHotBlogPageModelDataWithPage(
    int page, {
    int pageSize = 10,
    int? blogType,
    int? categary,
    int? squareId,
    int? userId,
    int? shareType,
  }) async {
    final query = <String, dynamic>{'pageNo': page, 'pageSize': pageSize};
    if (blogType != null) query['blogType'] = blogType;
    if (categary != null) query['categary'] = categary;
    if (squareId != null) query['squareId'] = squareId;
    if (userId != null) query['userId'] = userId;
    if (shareType != null) query['shareType'] = shareType;
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_HOT_PAGE,
      RequestType.get,
      queryParameters: query,
    );
    return parseBlogPageEnvelope(response.data);
  }

  @override
  Future<void> createBlog(BlogSaveReqVO req, {int? rewardAmount}) async {
    final data = req.toJson();
    if (rewardAmount != null && rewardAmount > 0) {
      data['rewardAmount'] = rewardAmount;
    }
    await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_SAVE,
      RequestType.post,
      data: data,
    );
  }

  @override
  Future<List<BlogBackgroundMusicItem>> searchBackgroundMusic({
    String? keyword,
    String tab = 'recommend',
    int pageNo = 1,
    int pageSize = 20,
  }) async {
    final query = <String, dynamic>{
      'pageNo': pageNo,
      'pageSize': pageSize,
      'tab': tab,
    };
    final trimmedKeyword = keyword?.trim();
    if (trimmedKeyword != null && trimmedKeyword.isNotEmpty) {
      query['keyword'] = trimmedKeyword;
    }
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_BACKGROUND_MUSIC_PAGE,
      RequestType.get,
      queryParameters: query,
    );
    final data = response.data;
    final payload = data is Map<String, dynamic> ? data['data'] : null;
    final list = payload is Map<String, dynamic>
        ? payload['list'] ?? payload['records']
        : null;
    if (list is! List) return const [];
    return list
        .whereType<Map>()
        .map(
          (item) =>
              BlogBackgroundMusicItem.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.musicUrl.isNotEmpty)
        .toList();
  }

  @override
  Future<bool> toggleBlogLike(
    int blogId, {
    required bool currentlyLiked,
  }) async {
    final url = ApiConstant.profileBlogLikePath(blogId);
    final Response response = await ApiBaseClient.safeApiCall(
      url,
      currentlyLiked ? RequestType.delete : RequestType.post,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '点赞接口返回格式错误';
    }
    final code = data['code'];
    if (code != null && code != 0 && code != '0') {
      throw data['msg']?.toString() ?? '操作失败';
    }
    if (data['data'] != true) {
      throw data['msg']?.toString() ?? '操作失败';
    }
    return !currentlyLiked;
  }

  static bool _parseBooleanData(dynamic raw, {String errorHint = '操作失败'}) {
    if (raw is! Map<String, dynamic>) {
      throw '$errorHint：返回格式错误';
    }
    final code = raw['code'];
    if (code != null && code != 0 && code != '0') {
      throw raw['msg']?.toString() ?? errorHint;
    }
    if (raw['data'] != true) {
      throw raw['msg']?.toString() ?? errorHint;
    }
    return true;
  }

  @override
  Future<bool> recordBlogShare(int blogId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.blogSharePath(blogId),
      RequestType.post,
    );
    _parseBooleanData(response.data, errorHint: '分享失败');
    return true;
  }

  @override
  Future<BlogItem?> fetchBlogItemById(int blogId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.blogDetailPath(blogId),
      RequestType.get,
    );
    final raw = response.data;
    if (raw is! Map<String, dynamic>) return null;
    final code = raw['code'];
    if (code != null && code != 0 && code != '0') {
      return null;
    }
    final data = raw['data'];
    if (data is! Map<String, dynamic>) return null;
    return BlogItem.fromJson(normalizeBlogItemJson(data));
  }

  @override
  Future<bool> deleteMyBlog(int blogId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.blogDeletePath(blogId),
      RequestType.delete,
    );
    _parseBooleanData(response.data, errorHint: '删除失败');
    return true;
  }

  @override
  Future<bool> favoriteBlog(int blogId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.blogFavoritePath(blogId),
      RequestType.post,
    );
    _parseBooleanData(response.data, errorHint: '收藏失败');
    return true;
  }

  @override
  Future<bool> unfavoriteBlog(int blogId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.blogFavoritePath(blogId),
      RequestType.delete,
    );
    _parseBooleanData(response.data, errorHint: '取消收藏失败');
    return true;
  }

  @override
  Future<bool> toggleBlogFavorite(
    int blogId, {
    required bool currentlyCollected,
  }) async {
    if (currentlyCollected) {
      await unfavoriteBlog(blogId);
      return false;
    }
    await favoriteBlog(blogId);
    return true;
  }

  @override
  Future<BlogPageModelData> getMyFavoritesPage(
    int page, {
    int pageSize = 10,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_MY_FAVORITES_PAGE,
      RequestType.get,
      queryParameters: {'pageNo': page, 'pageSize': pageSize},
    );
    return parseBlogPageEnvelope(response.data);
  }

  @override
  Future<bool> markBlogNotInterested(int blogId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.blogDislikePath(blogId),
      RequestType.post,
    );
    _parseBooleanData(response.data, errorHint: '操作失败');
    return true;
  }

  @override
  Future<bool> reportBlog(
    int blogId, {
    required int reason,
    String? description,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.blogReportPath(blogId),
      RequestType.post,
      data: {
        'reason': reason,
        if (description != null && description.trim().isNotEmpty)
          'description': description.trim(),
      },
    );
    _parseBooleanData(response.data, errorHint: '举报失败');
    return true;
  }

  @override
  Future<void> recordBlogBrowse(int blogId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.blogBrowsePath(blogId),
      RequestType.post,
    );
    _parseBooleanData(response.data, errorHint: '记录浏览失败');
  }

  @override
  Future<BlogBrowseHistoryPageData> getBlogBrowseHistoryPage(
    int pageNo, {
    int pageSize = 20,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_BROWSE_HISTORY_PAGE,
      RequestType.get,
      queryParameters: {'pageNo': pageNo, 'pageSize': pageSize},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '博客足迹接口返回格式错误';
    }
    if (!_isOkCode(data['code'])) {
      throw data['msg']?.toString() ?? '请求失败';
    }
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const BlogBrowseHistoryPageData(list: [], total: 0);
    }
    return BlogBrowseHistoryPageData.fromJson(inner);
  }

  @override
  Future<void> deleteBlogBrowseHistoryIds(List<int> blogIds) async {
    if (blogIds.isEmpty) return;
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_BROWSE_HISTORY_DELETE,
      RequestType.delete,
      data: {'blogIds': blogIds},
    );
    _parseBooleanData(response.data, errorHint: '删除失败');
  }

  @override
  Future<void> cleanBlogBrowseHistory() async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.BLOG_BROWSE_HISTORY_CLEAN,
      RequestType.delete,
    );
    _parseBooleanData(response.data, errorHint: '清空失败');
  }

  bool _isOkCode(dynamic code) => code == null || code == 0 || code == '0';
}
