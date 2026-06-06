import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../../../blog/data/blog_page_parse.dart';
import '../../../blog/data/models/blog_page_model.dart';
import '../models/profile_models.dart';

final profileRepoProvider = Provider<IProfileRepo>((ref) => ProfileRepo());

abstract class IProfileRepo {
  Future<BlogMyPageResp> getMyPage();

  Future<BlogMyPageResp> getUserPage(int userId);

  Future<bool> updateMyShop(BlogShopSaveReq req);

  Future<bool> updateMemberUser(MemberUserUpdateReq req);

  Future<BlogShopResp?> getMyShop();

  Future<BlogPageModelData> getMyWorksPage(
    int pageNo, {
    int pageSize = 12,
    int? blogType,
  });

  Future<BlogPageModelData> getUserWorksPage(
    int userId,
    int pageNo, {
    int pageSize = 12,
    int? blogType,
  });

  Future<BlogPageModelData> getMyLikesPage(int pageNo, {int pageSize = 12});

  Future<BlogCollectionPageData> getMyCollectionsPage(
    int pageNo, {
    int pageSize = 12,
    String? name,
  });

  Future<BlogCollectionPageData> getUserCollectionsPage(
    int userId,
    int pageNo, {
    int pageSize = 12,
    String? name,
  });

  Future<BlogCollectionDetailResp> getCollectionDetail(int id);

  Future<int> createCollection(BlogCollectionSaveReq req);

  Future<bool> updateCollection(int id, BlogCollectionSaveReq req);

  Future<BlogShopProductPageData> getMyShopProductsPage(
    int pageNo, {
    int pageSize = 12,
    String? name,
    int? status,
  });

  Future<BlogShopProductPageData> getUserShopProductsPage(
    int userId,
    int pageNo, {
    int pageSize = 12,
    String? name,
  });

  Future<int> createShopProduct(BlogShopProductSaveReq req);

  Future<bool> deleteShopProduct(int id);

  Future<bool> addCollectionItem({
    required int collectionId,
    required int blogId,
    int? sort,
  });

  Future<bool> removeCollectionItem({
    required int collectionId,
    required int blogId,
  });

  Future<bool> followUser(int userId);

  Future<bool> unfollowUser(int userId);

  Future<bool> isFollowedByMe(int userId);

  Future<BlogPageModelData> getMyFollowsFeedPage(
    int pageNo, {
    int pageSize = 10,
  });

  Future<BlogFollowMemberPageData> getMyFollowMembersPage(
    int pageNo, {
    int pageSize = 20,
  });

  Future<BlogFollowMemberPageData> getMyFollowerMembersPage(
    int pageNo, {
    int pageSize = 20,
  });
}

bool _isOkCode(dynamic code) => code == null || code == 0 || code == '0';

void _ensureEnvelope(Map<String, dynamic> root) {
  if (!_isOkCode(root['code'])) {
    throw root['msg']?.toString() ?? '请求失败';
  }
}

class ProfileRepo implements IProfileRepo {
  @override
  Future<BlogMyPageResp> getMyPage() async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PROFILE_MY_PAGE,
      RequestType.get,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '我的主页接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      throw '我的主页数据为空';
    }
    return BlogMyPageResp.fromJson(inner);
  }

  @override
  Future<BlogMyPageResp> getUserPage(int userId) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.profileUserPagePath(userId),
      RequestType.get,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '用户主页接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      throw '用户主页数据为空';
    }
    return BlogMyPageResp.fromJson(inner);
  }

  @override
  Future<bool> updateMyShop(BlogShopSaveReq req) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PROFILE_MY_SHOP,
      RequestType.put,
      data: req.toJson(),
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '更新店铺返回格式错误';
    }
    _ensureEnvelope(data);
    return data['data'] == true;
  }

  @override
  Future<bool> updateMemberUser(MemberUserUpdateReq req) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.MEMBER_USER_UPDATE,
      RequestType.put,
      data: req.toJson(),
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '更新用户信息返回格式错误';
    }
    _ensureEnvelope(data);
    return data['data'] == true;
  }

  @override
  Future<BlogShopResp?> getMyShop() async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PROFILE_MY_SHOP,
      RequestType.get,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '店铺接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner == null) return null;
    if (inner is! Map<String, dynamic>) return null;
    return BlogShopResp.fromJson(inner);
  }

  @override
  Future<BlogPageModelData> getMyWorksPage(
    int pageNo, {
    int pageSize = 12,
    int? blogType,
  }) async {
    final query = <String, dynamic>{'pageNo': pageNo, 'pageSize': pageSize};
    if (blogType != null) query['blogType'] = blogType;
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PROFILE_MY_WORKS_PAGE,
      RequestType.get,
      queryParameters: query,
    );
    return _parseBlogPage(response.data);
  }

  @override
  Future<BlogPageModelData> getUserWorksPage(
    int userId,
    int pageNo, {
    int pageSize = 12,
    int? blogType,
  }) async {
    final query = <String, dynamic>{'pageNo': pageNo, 'pageSize': pageSize};
    if (blogType != null) query['blogType'] = blogType;
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.profileUserWorksPagePath(userId),
      RequestType.get,
      queryParameters: query,
    );
    return _parseBlogPage(response.data);
  }

  @override
  Future<BlogPageModelData> getMyLikesPage(
    int pageNo, {
    int pageSize = 12,
  }) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PROFILE_MY_LIKES_PAGE,
      RequestType.get,
      queryParameters: {'pageNo': pageNo, 'pageSize': pageSize},
    );
    return _parseBlogPage(response.data);
  }

  @override
  Future<BlogCollectionPageData> getMyCollectionsPage(
    int pageNo, {
    int pageSize = 12,
    String? name,
  }) async {
    final query = <String, dynamic>{'pageNo': pageNo, 'pageSize': pageSize};
    if (name != null && name.isNotEmpty) query['name'] = name;
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PROFILE_MY_COLLECTIONS_PAGE,
      RequestType.get,
      queryParameters: query,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '合集接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const BlogCollectionPageData(list: [], total: 0);
    }
    return BlogCollectionPageData.fromJson(inner);
  }

  @override
  Future<BlogCollectionPageData> getUserCollectionsPage(
    int userId,
    int pageNo, {
    int pageSize = 12,
    String? name,
  }) async {
    final query = <String, dynamic>{'pageNo': pageNo, 'pageSize': pageSize};
    if (name != null && name.isNotEmpty) query['name'] = name;
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.profileUserCollectionsPagePath(userId),
      RequestType.get,
      queryParameters: query,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '合集接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const BlogCollectionPageData(list: [], total: 0);
    }
    return BlogCollectionPageData.fromJson(inner);
  }

  @override
  Future<BlogCollectionDetailResp> getCollectionDetail(int id) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.profileCollectionDetailPath(id),
      RequestType.get,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '合集详情接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      throw '合集详情数据为空';
    }
    return BlogCollectionDetailResp.fromJson(inner);
  }

  @override
  Future<int> createCollection(BlogCollectionSaveReq req) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PROFILE_COLLECTIONS,
      RequestType.post,
      data: req.toJson(),
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '创建合集返回格式错误';
    }
    _ensureEnvelope(data);
    final id = data['data'];
    if (id is num) return id.toInt();
    throw '未返回合集 id';
  }

  @override
  Future<bool> updateCollection(int id, BlogCollectionSaveReq req) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.profileCollectionDetailPath(id),
      RequestType.put,
      data: req.toJson(),
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '更新合集返回格式错误';
    }
    _ensureEnvelope(data);
    return data['data'] == true;
  }

  @override
  Future<BlogShopProductPageData> getMyShopProductsPage(
    int pageNo, {
    int pageSize = 12,
    String? name,
    int? status,
  }) async {
    final query = <String, dynamic>{'pageNo': pageNo, 'pageSize': pageSize};
    if (name != null && name.isNotEmpty) query['name'] = name;
    if (status != null) query['status'] = status;
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PROFILE_MY_SHOP_PRODUCTS_PAGE,
      RequestType.get,
      queryParameters: query,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '商品接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const BlogShopProductPageData(list: [], total: 0);
    }
    return BlogShopProductPageData.fromJson(inner);
  }

  @override
  Future<BlogShopProductPageData> getUserShopProductsPage(
    int userId,
    int pageNo, {
    int pageSize = 12,
    String? name,
  }) async {
    final query = <String, dynamic>{'pageNo': pageNo, 'pageSize': pageSize};
    if (name != null && name.isNotEmpty) query['name'] = name;
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.profileUserShopProductsPagePath(userId),
      RequestType.get,
      queryParameters: query,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '商品接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const BlogShopProductPageData(list: [], total: 0);
    }
    return BlogShopProductPageData.fromJson(inner);
  }

  @override
  Future<int> createShopProduct(BlogShopProductSaveReq req) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PROFILE_MY_SHOP_PRODUCTS,
      RequestType.post,
      data: req.toJson(),
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '创建商品返回格式错误';
    }
    _ensureEnvelope(data);
    final id = data['data'];
    if (id is num) return id.toInt();
    throw '未返回商品 id';
  }

  @override
  Future<bool> deleteShopProduct(int id) async {
    final Response response = await ApiBaseClient.safeApiCall(
      '${ApiConstant.PROFILE_MY_SHOP_PRODUCTS}/$id',
      RequestType.delete,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '删除商品返回格式错误';
    }
    _ensureEnvelope(data);
    final ok = data['data'];
    return ok == true;
  }

  @override
  Future<bool> addCollectionItem({
    required int collectionId,
    required int blogId,
    int? sort,
  }) async {
    final body = <String, dynamic>{
      'collectionId': collectionId,
      'blogId': blogId,
    };
    if (sort != null) body['sort'] = sort;
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PROFILE_COLLECTIONS_ITEMS,
      RequestType.post,
      data: body,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '合集添加作品返回格式错误';
    }
    _ensureEnvelope(data);
    return data['data'] == true;
  }

  @override
  Future<bool> removeCollectionItem({
    required int collectionId,
    required int blogId,
  }) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PROFILE_COLLECTIONS_ITEMS,
      RequestType.delete,
      queryParameters: {'collectionId': collectionId, 'blogId': blogId},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '合集移除作品返回格式错误';
    }
    _ensureEnvelope(data);
    return data['data'] == true;
  }

  @override
  Future<bool> followUser(int userId) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.profileFollowsPath(userId),
      RequestType.post,
    );
    return _parseBoolEnvelope(response.data);
  }

  @override
  Future<bool> unfollowUser(int userId) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.profileFollowsPath(userId),
      RequestType.delete,
    );
    return _parseBoolEnvelope(response.data);
  }

  @override
  Future<bool> isFollowedByMe(int userId) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.profileUserFollowedByMePath(userId),
      RequestType.get,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '关注状态接口返回格式错误';
    }
    _ensureEnvelope(data);
    return data['data'] == true;
  }

  @override
  Future<BlogPageModelData> getMyFollowsFeedPage(
    int pageNo, {
    int pageSize = 10,
  }) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PROFILE_MY_FOLLOWS_FEED_PAGE,
      RequestType.get,
      queryParameters: {'pageNo': pageNo, 'pageSize': pageSize},
    );
    return _parseBlogPage(response.data);
  }

  @override
  Future<BlogFollowMemberPageData> getMyFollowMembersPage(
    int pageNo, {
    int pageSize = 20,
  }) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PROFILE_MY_FOLLOWS_MEMBERS_PAGE,
      RequestType.get,
      queryParameters: {'pageNo': pageNo, 'pageSize': pageSize},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '关注列表返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const BlogFollowMemberPageData(list: [], total: 0);
    }
    return BlogFollowMemberPageData.fromJson(inner);
  }

  @override
  Future<BlogFollowMemberPageData> getMyFollowerMembersPage(
    int pageNo, {
    int pageSize = 20,
  }) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PROFILE_MY_FOLLOWERS_MEMBERS_PAGE,
      RequestType.get,
      queryParameters: {'pageNo': pageNo, 'pageSize': pageSize},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '粉丝列表返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const BlogFollowMemberPageData(list: [], total: 0);
    }
    return BlogFollowMemberPageData.fromJson(inner);
  }

  bool _parseBoolEnvelope(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      throw '接口返回格式错误';
    }
    _ensureEnvelope(raw);
    return raw['data'] == true;
  }

  BlogPageModelData _parseBlogPage(dynamic raw) {
    return parseBlogPageEnvelope(raw, errorMessage: '作品分页返回格式错误');
  }
}
