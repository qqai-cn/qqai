import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../models/member_address_models.dart';

final memberAddressRepoProvider = Provider<IMemberAddressRepo>(
  (ref) => MemberAddressRepo(),
);

abstract class IMemberAddressRepo {
  Future<List<MemberAddress>> getList();

  Future<int> create(MemberAddressSaveReq req);

  Future<bool> update(MemberAddressSaveReq req);

  Future<bool> delete(int id);
}

bool _isOkCode(dynamic code) => code == null || code == 0 || code == '0';

void _ensureEnvelope(Map<String, dynamic> root) {
  if (!_isOkCode(root['code'])) {
    throw root['msg']?.toString() ?? '请求失败';
  }
}

class MemberAddressRepo implements IMemberAddressRepo {
  @override
  Future<List<MemberAddress>> getList() async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.MEMBER_ADDRESS_LIST,
      RequestType.get,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '收货地址接口返回格式错误';
    }
    _ensureEnvelope(data);
    final inner = data['data'];
    if (inner is! List) return const [];
    return inner
        .whereType<Map<String, dynamic>>()
        .map(MemberAddress.fromJson)
        .toList();
  }

  @override
  Future<int> create(MemberAddressSaveReq req) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.MEMBER_ADDRESS_CREATE,
      RequestType.post,
      data: req.toJson(),
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '新增地址返回格式错误';
    }
    _ensureEnvelope(data);
    return (data['data'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<bool> update(MemberAddressSaveReq req) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.MEMBER_ADDRESS_UPDATE,
      RequestType.put,
      data: req.toJson(),
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '更新地址返回格式错误';
    }
    _ensureEnvelope(data);
    return data['data'] == true;
  }

  @override
  Future<bool> delete(int id) async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.MEMBER_ADDRESS_DELETE,
      RequestType.delete,
      queryParameters: {'id': id},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) _ensureEnvelope(data);
    return true;
  }
}
