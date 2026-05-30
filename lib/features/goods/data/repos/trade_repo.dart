import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../models/trade_models.dart';

final tradeRepoProvider = Provider<ITradeRepo>((ref) => TradeRepo());

abstract class ITradeRepo {
  Future<BrowseHistoryPageData> getBrowseHistoryPage(
    int pageNo, {
    int pageSize = 20,
  });

  Future<void> deleteBrowseHistorySpuIds(List<int> spuIds);

  Future<void> cleanBrowseHistory();

  Future<TradeCartListData> getCartList();

  Future<void> addCart({required int skuId, required int count});

  Future<void> updateCartCount({required int cartId, required int count});

  Future<void> updateCartSelected({required int cartId, required bool selected});

  Future<void> deleteCartItems(List<int> cartIds);

  Future<TradeOrderPageData> getOrderPage(
    int pageNo, {
    int pageSize = 10,
    int? status,
  });
}

bool _isOkCode(dynamic code) => code == null || code == 0 || code == '0';

void _ensureEnvelope(Map<String, dynamic> root) {
  if (!_isOkCode(root['code'])) {
    throw root['msg']?.toString() ?? '请求失败';
  }
}

class TradeRepo implements ITradeRepo {
  @override
  Future<BrowseHistoryPageData> getBrowseHistoryPage(
    int pageNo, {
    int pageSize = 20,
  }) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.MALL_BROWSE_HISTORY_PAGE,
      RequestType.get,
      queryParameters: {'pageNo': pageNo, 'pageSize': pageSize},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '足迹接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const BrowseHistoryPageData(list: [], total: 0);
    }
    return BrowseHistoryPageData.fromJson(inner);
  }

  @override
  Future<void> deleteBrowseHistorySpuIds(List<int> spuIds) async {
    if (spuIds.isEmpty) return;
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.MALL_BROWSE_HISTORY_DELETE,
      RequestType.delete,
      data: {'spuIds': spuIds},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) _ensureEnvelope(data);
  }

  @override
  Future<void> cleanBrowseHistory() async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.MALL_BROWSE_HISTORY_CLEAN,
      RequestType.delete,
    );
    final data = response.data;
    if (data is Map<String, dynamic>) _ensureEnvelope(data);
  }

  @override
  Future<TradeCartListData> getCartList() async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.TRADE_CART_LIST,
      RequestType.get,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '购物车接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const TradeCartListData();
    }
    return TradeCartListData.fromJson(inner);
  }

  @override
  Future<void> addCart({required int skuId, required int count}) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.TRADE_CART_ADD,
      RequestType.post,
      data: {'skuId': skuId, 'count': count},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) _ensureEnvelope(data);
  }

  @override
  Future<void> updateCartCount({required int cartId, required int count}) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.TRADE_CART_UPDATE_COUNT,
      RequestType.put,
      data: {'id': cartId, 'count': count},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) _ensureEnvelope(data);
  }

  @override
  Future<void> updateCartSelected({
    required int cartId,
    required bool selected,
  }) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.TRADE_CART_UPDATE_SELECTED,
      RequestType.put,
      data: {'id': cartId, 'selected': selected},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) _ensureEnvelope(data);
  }

  @override
  Future<void> deleteCartItems(List<int> cartIds) async {
    if (cartIds.isEmpty) return;
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.TRADE_CART_DELETE,
      RequestType.delete,
      queryParameters: {'ids': cartIds.join(',')},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) _ensureEnvelope(data);
  }

  @override
  Future<TradeOrderPageData> getOrderPage(
    int pageNo, {
    int pageSize = 10,
    int? status,
  }) async {
    final query = <String, dynamic>{'pageNo': pageNo, 'pageSize': pageSize};
    if (status != null) query['status'] = status;
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.TRADE_ORDER_PAGE,
      RequestType.get,
      queryParameters: query,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '订单接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const TradeOrderPageData(list: [], total: 0);
    }
    return TradeOrderPageData.fromJson(inner);
  }
}
