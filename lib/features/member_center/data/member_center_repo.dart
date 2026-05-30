import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constant/api_constant.dart';
import '../../../util/api_base_client.dart';
import 'member_center_models.dart';

final memberCenterRepoProvider = Provider<IMemberCenterRepo>(
  (ref) => MemberCenterRepo(),
);

abstract class IMemberCenterRepo {
  Future<MemberCenterData> getMemberCenter();

  Future<void> signIn();
}

bool _isOkCode(dynamic code) => code == null || code == 0 || code == '0';

void _ensureEnvelope(Map<String, dynamic> root) {
  if (!_isOkCode(root['code'])) {
    throw root['msg']?.toString() ?? '请求失败';
  }
}

Map<String, dynamic> _unwrapMap(Response response, String error) {
  final data = response.data;
  if (data is! Map<String, dynamic>) throw error;
  _ensureEnvelope(data);
  final inner = data['data'];
  return inner is Map<String, dynamic> ? inner : <String, dynamic>{};
}

List<T> _unwrapList<T>(
  Response response,
  T Function(Map<String, dynamic> json) fromJson,
) {
  final data = response.data;
  if (data is! Map<String, dynamic>) return <T>[];
  _ensureEnvelope(data);
  final inner = data['data'];
  final rawList = inner is Map<String, dynamic> ? inner['list'] : inner;
  if (rawList is! List) return <T>[];
  return rawList
      .whereType<Map<String, dynamic>>()
      .map(fromJson)
      .toList(growable: false);
}

class MemberCenterRepo implements IMemberCenterRepo {
  @override
  Future<MemberCenterData> getMemberCenter() async {
    final responses = await Future.wait<Response<dynamic>>([
      ApiBaseClient.safeApiCall(ApiConstant.MEMBER_USER_GET, RequestType.get),
      ApiBaseClient.safeApiCall(ApiConstant.MEMBER_LEVEL_LIST, RequestType.get),
      ApiBaseClient.safeApiCall(
        ApiConstant.MEMBER_SIGN_IN_SUMMARY,
        RequestType.get,
      ),
      ApiBaseClient.safeApiCall(
        ApiConstant.MEMBER_SIGN_IN_CONFIG_LIST,
        RequestType.get,
      ),
      ApiBaseClient.safeApiCall(
        ApiConstant.MEMBER_POINT_RECORD_PAGE,
        RequestType.get,
        queryParameters: {'pageNo': 1, 'pageSize': 100},
      ),
      ApiBaseClient.safeApiCall(
        ApiConstant.MEMBER_EXPERIENCE_RECORD_PAGE,
        RequestType.get,
        queryParameters: {'pageNo': 1, 'pageSize': 100},
      ),
    ]);

    final user = MemberUserInfo.fromJson(
      _unwrapMap(responses[0], '会员信息接口返回格式错误'),
    );
    final levels = _unwrapList(responses[1], MemberLevelInfo.fromJson)
      ..sort((a, b) => a.level.compareTo(b.level));
    final signInSummary = MemberSignInSummary.fromJson(
      _unwrapMap(responses[2], '签到统计接口返回格式错误'),
    );
    final signInConfigs = _unwrapList(responses[3], MemberSignInConfig.fromJson)
      ..sort((a, b) => a.day.compareTo(b.day));
    final pointRecords = _unwrapList(responses[4], MemberPointRecord.fromJson);
    final experienceRecords = _unwrapList(
      responses[5],
      MemberExperienceRecord.fromJson,
    );

    return MemberCenterData(
      user: user,
      levels: levels,
      signInSummary: signInSummary,
      signInConfigs: signInConfigs,
      pointRecords: pointRecords,
      experienceRecords: experienceRecords,
    );
  }

  @override
  Future<void> signIn() async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.MEMBER_SIGN_IN_CREATE,
      RequestType.post,
    );
    final data = response.data;
    if (data is Map<String, dynamic>) _ensureEnvelope(data);
  }
}
