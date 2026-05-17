import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../models/goods_model.dart';
import '../models/mall_product_model.dart';

// Repo Provider（按 blog 的格式：Provider 放在 repo 文件里）
final goodsRepoProvider = Provider<IGoodsRepo>((ref) => GoodsRepo());

abstract class IGoodsRepo {
  Future<MallProductPageData> getMallProductsPage(
    int pageNo, {
    int pageSize = 20,
    String? keyword,
  });

  Future<MallProduct?> getMallProduct(int id);

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
