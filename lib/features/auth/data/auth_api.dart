import 'package:dio/dio.dart';

import '../../../constant/api_constant.dart';
import '../../../util/api_base_client.dart';

class LoginResponse {
  final String token;
  final String? refreshToken;
  final String? userId;

  const LoginResponse({required this.token, this.refreshToken, this.userId});
}

Future<LoginResponse> loginApi({
  required String username,
  required String password,
}) async {
  final Response response = await ApiBaseClient.safeApiCall(
    ApiConstant.LOGIN,
    RequestType.post,
    data: {
      'mobile': username,
      'password': password,
    },
  );

  final data = response.data;
  if (data is! Map) {
    throw '登录接口返回格式错误';
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

  final data = response.data;
  if (data is! Map) {
    throw '刷新令牌接口返回格式错误';
  }

  final dynamic payload = (data['data'] is Map) ? data['data'] : data;

  String? token;
  String? newRefreshToken;
  if (payload is Map) {
    token =
        (payload['accessToken'] ??
                payload['token'] ??
                payload['access_token'] ??
                payload['tokenValue'])
            ?.toString();
    newRefreshToken = (payload['refreshToken'] ?? payload['refresh_token'])?.toString();
  }

  if (token == null || token.isEmpty) {
    throw data['msg']?.toString() ?? data['message']?.toString() ?? '未获取到 token';
  }

  final userId = (payload is Map ? payload['userId'] : null)?.toString();
  return LoginResponse(token: token, refreshToken: newRefreshToken, userId: userId);
}

