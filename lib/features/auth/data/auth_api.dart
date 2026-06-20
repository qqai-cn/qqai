import 'package:dio/dio.dart';

import '../../../constant/api_constant.dart';
import '../../../util/api_base_client.dart';

class LoginResponse {
  final String token;
  final String? refreshToken;
  final String? userId;

  const LoginResponse({required this.token, this.refreshToken, this.userId});
}

bool _isAuthApiSuccessCode(dynamic code) =>
    code == null || code == 0 || code == '0';

LoginResponse _parseAuthLoginEnvelope(dynamic data, {required String badFormatMessage}) {
  if (data is! Map) {
    throw badFormatMessage;
  }
  if (!_isAuthApiSuccessCode(data['code'])) {
    throw data['msg']?.toString() ?? data['message']?.toString() ?? '请求失败';
  }

  // Common patterns:
  // - { code, data: { accessToken } }
  // - { data: { token } }
  // - { accessToken }
  final dynamic payload = (data['data'] is Map) ? data['data'] : data;

  String? token;
  String? refreshToken;
  if (payload is Map) {
    token =
        (payload['accessToken'] ??
                payload['token'] ??
                payload['access_token'] ??
                payload['tokenValue'])
            ?.toString();
    refreshToken = (payload['refreshToken'] ?? payload['refresh_token'])?.toString();
  }

  if (token == null || token.isEmpty) {
    throw data['msg']?.toString() ?? data['message']?.toString() ?? '未获取到 token';
  }

  final userId = (payload is Map ? payload['userId'] : null)?.toString();
  return LoginResponse(token: token, refreshToken: refreshToken, userId: userId);
}

Future<LoginResponse> loginApi({
  String? mobile,
  int? qqId,
  required String password,
}) async {
  final data = <String, dynamic>{
    'password': password,
  };
  if (qqId != null) {
    data['qqId'] = qqId;
  } else if (mobile != null && mobile.isNotEmpty) {
    data['mobile'] = mobile;
  }

  final Response response = await ApiBaseClient.safeApiCall(
    ApiConstant.LOGIN,
    RequestType.post,
    data: data,
  );

  return _parseAuthLoginEnvelope(response.data, badFormatMessage: '登录接口返回格式错误');
}

Future<LoginResponse> registerApi({
  required String mobile,
  required String password,
  required String username,
  required String idCard,
}) async {
  final Response response = await ApiBaseClient.safeApiCall(
    ApiConstant.REGISTER,
    RequestType.post,
    data: {
      'mobile': mobile,
      'password': password,
      'username': username,
      'idCard': idCard,
    },
  );

  return _parseAuthLoginEnvelope(response.data, badFormatMessage: '注册接口返回格式错误');
}

Future<LoginResponse> refreshTokenApi({
  required String refreshToken,
}) async {
  final Response response = await ApiBaseClient.safeApiCall(
    ApiConstant.REFRESH_TOKEN,
    RequestType.post,
    queryParameters: {
      'refreshToken': refreshToken,
    },
  );

  return _parseAuthLoginEnvelope(response.data, badFormatMessage: '刷新令牌接口返回格式错误');
}

