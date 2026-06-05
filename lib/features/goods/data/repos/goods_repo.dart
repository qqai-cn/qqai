import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../models/goods_model.dart';
import '../models/mall_product_model.dart';
import '../models/trade_models.dart';

// Repo Provider（按 blog 的格式：Provider 放在 repo 文件里）
final goodsRepoProvider = Provider<IGoodsRepo>((ref) => GoodsRepo());

abstract class IGoodsRepo {
  Future<MallProductPageData> getMallProductsPage(
    int pageNo, {
    int pageSize = 20,
    String? keyword,
  });

  /// 我发布的商品分页（含上架与下架，需登录）。
  Future<MallProductPageData> getMyProductsPage(
    int pageNo, {
    int pageSize = 20,
  });

  /// 他人店铺在售商品分页。
  Future<MallProductPageData> getUserProductsPage(
    int userId,
    int pageNo, {
    int pageSize = 20,
  });

  /// 更新我发布商品的上架状态（0 下架，1 上架，需登录）。
  Future<void> updateMyProductStatus(int spuId, int status);

  Future<MallProduct?> getMallProduct(int id);

  /// 记录商品浏览（足迹，需登录）。
  Future<void> recordProductBrowse(int spuId);

  /// 是否已收藏该商品（需登录）。
  Future<bool> isProductFavorite(int spuId);

  /// 收藏商品（需登录）。
  Future<void> favoriteProduct(int spuId);

  /// 取消收藏商品（需登录）。
  Future<void> unfavoriteProduct(int spuId);

  /// 切换收藏状态，返回切换后是否已收藏。
  Future<bool> toggleProductFavorite(
    int spuId, {
    required bool currentlyCollected,
  });

  /// 商品收藏分页（需登录）。
  Future<BrowseHistoryPageData> getProductFavoritePage(
    int pageNo, {
    int pageSize = 20,
  });

  Future<List<GoodsModel>> getAllGoodss();
  Future<GoodsModel?> getGoodsById(String id);
  Future<void> addGoods(GoodsModel item);
  Future<void> updateGoods(GoodsModel item);
  Future<void> deleteGoods(String id);
}

class GoodsRepo implements IGoodsRepo {
  final List<GoodsModel> _items = [];

  bool _isOkCode(dynamic code) => code == null || code == 0 || code == '0';

  void _ensureEnvelope(Map<String, dynamic> root) {
    if (!_isOkCode(root['code'])) {
      throw root['msg']?.toString() ?? '请求失败';
    }
  }

  @override
  Future<MallProductPageData> getMallProductsPage(
    int pageNo, {
    int pageSize = 20,
    String? keyword,
  }) async {
    final query = <String, dynamic>{'pageNo': pageNo, 'pageSize': pageSize};
    if (keyword != null && keyword.trim().isNotEmpty) {
      query['keyword'] = keyword.trim();
    }
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.MALL_PRODUCTS_PAGE,
      RequestType.get,
      queryParameters: query,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '商场商品接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const MallProductPageData(list: [], total: 0);
    }
    return MallProductPageData.fromJson(inner);
  }

  @override
  Future<MallProductPageData> getMyProductsPage(
    int pageNo, {
    int pageSize = 20,
  }) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.MALL_PRODUCT_MY_PAGE,
      RequestType.get,
      queryParameters: {'pageNo': pageNo, 'pageSize': pageSize},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '我的商品接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const MallProductPageData(list: [], total: 0);
    }
    return MallProductPageData.fromJson(inner);
  }

  @override
  Future<MallProductPageData> getUserProductsPage(
    int userId,
    int pageNo, {
    int pageSize = 20,
  }) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.mallProductUserPagePath(userId),
      RequestType.get,
      queryParameters: {'pageNo': pageNo, 'pageSize': pageSize},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '店铺商品接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const MallProductPageData(list: [], total: 0);
    }
    return MallProductPageData.fromJson(inner);
  }

  @override
  Future<void> updateMyProductStatus(int spuId, int status) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.MALL_PRODUCT_UPDATE_STATUS,
      RequestType.put,
      data: {'id': spuId, 'status': status},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      _ensureEnvelope(data);
    }
  }

  @override
  Future<MallProduct?> getMallProduct(int id) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.MALL_PRODUCT_DETAIL,
      RequestType.get,
      queryParameters: {'id': id},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '商场商品详情返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) return null;
    return MallProduct.fromJson(inner);
  }

  @override
  Future<void> recordProductBrowse(int spuId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.productBrowsePath(spuId),
      RequestType.post,
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      _ensureEnvelope(data);
    }
  }

  bool _parseBooleanData(dynamic raw, {String errorHint = '操作失败'}) {
    if (raw is! Map<String, dynamic>) {
      throw '$errorHint：返回格式错误';
    }
    _ensureEnvelope(raw);
    return raw['data'] == true;
  }

  @override
  Future<bool> isProductFavorite(int spuId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.MALL_PRODUCT_FAVORITE_EXISTS,
      RequestType.get,
      queryParameters: {'spuId': spuId},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '收藏状态接口返回格式错误';
    }
    _ensureEnvelope(data);
    return data['data'] == true;
  }

  @override
  Future<void> favoriteProduct(int spuId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.MALL_PRODUCT_FAVORITE_CREATE,
      RequestType.post,
      data: {'spuId': spuId},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      _ensureEnvelope(data);
    }
  }

  @override
  Future<void> unfavoriteProduct(int spuId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.MALL_PRODUCT_FAVORITE_DELETE,
      RequestType.delete,
      data: {'spuId': spuId},
    );
    _parseBooleanData(response.data, errorHint: '取消收藏失败');
  }

  @override
  Future<bool> toggleProductFavorite(
    int spuId, {
    required bool currentlyCollected,
  }) async {
    if (currentlyCollected) {
      await unfavoriteProduct(spuId);
      return false;
    }
    await favoriteProduct(spuId);
    return true;
  }

  @override
  Future<BrowseHistoryPageData> getProductFavoritePage(
    int pageNo, {
    int pageSize = 20,
  }) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.MALL_PRODUCT_FAVORITE_PAGE,
      RequestType.get,
      queryParameters: {'pageNo': pageNo, 'pageSize': pageSize},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '商品收藏接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const BrowseHistoryPageData(list: [], total: 0);
    }
    return BrowseHistoryPageData.fromJson(inner);
  }

  @override
  Future<List<GoodsModel>> getAllGoodss() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<GoodsModel?> getGoodsById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addGoods(GoodsModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
  }

  @override
  Future<void> updateGoods(GoodsModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> deleteGoods(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }
}
