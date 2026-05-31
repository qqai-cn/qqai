import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../../models/goods_comment_item.dart';
import '../models/product_comment_page_data.dart';

final productCommentRepoProvider = Provider<ProductCommentRepo>(
  (ref) => ProductCommentRepo(),
);

class ProductCommentRepo {
  bool _isOkCode(dynamic code) => code == null || code == 0 || code == '0';

  void _ensureEnvelope(Map<String, dynamic> root) {
    if (!_isOkCode(root['code'])) {
      throw root['msg']?.toString() ?? '请求失败';
    }
  }

  /// [type] 0 全部、1 好评、2 中评、3 差评
  Future<ProductCommentPageData> getCommentPage({
    required int spuId,
    int type = 0,
    int pageNo = 1,
    int pageSize = 20,
  }) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.PRODUCT_COMMENT_PAGE,
      RequestType.get,
      queryParameters: {
        'spuId': spuId,
        'type': type,
        'pageNo': pageNo,
        'pageSize': pageSize,
      },
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '商品评价接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! Map<String, dynamic>) {
      return const ProductCommentPageData(list: [], total: 0);
    }
    final raw = inner['list'] as List<dynamic>? ?? const [];
    final list = raw
        .whereType<Map<String, dynamic>>()
        .map(GoodsCommentItem.fromApiJson)
        .toList();
    return ProductCommentPageData(
      list: list,
      total: (inner['total'] as num?)?.toInt() ?? list.length,
    );
  }
}
