import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../models/area_models.dart';

final areaRepoProvider = Provider<AreaRepo>((ref) => AreaRepo());

class AreaRepo {
  Future<List<AppAreaNode>> getTree() async {
    final Response response = await ApiBaseClient.safeApiCall(
      ApiConstant.SYSTEM_AREA_TREE,
      RequestType.get,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw '地区接口返回格式错误';
    }
    final code = data['code'];
    if (code != null && code != 0 && code != '0') {
      throw data['msg']?.toString() ?? '地区加载失败';
    }
    final inner = data['data'];
    if (inner is! List) return const [];
    return inner
        .map((e) => AppAreaNode.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final areaTreeProvider = FutureProvider<List<AppAreaNode>>((ref) async {
  return ref.watch(areaRepoProvider).getTree();
});
