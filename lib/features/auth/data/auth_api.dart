import 'package:dio/dio.dart';

import '../../../constant/api_constant.dart';
import '../../../util/api_base_client.dart';

class LoginResponse {
  final String token;
  final String? userId;

  const LoginResponse({required this.token, this.userId});
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
  if (payload is Map) {
    token =
        (payload['accessToken'] ??
                payload['token'] ??
                payload['access_token'] ??
                payload['tokenValue'])
            ?.toString();
  }

  if (token == null || token.isEmpty) {
    throw data['msg']?.toString() ?? data['message']?.toString() ?? '未获取到 token';
  }

  final userId = (payload is Map ? payload['userId'] : null)?.toString();
  return LoginResponse(token: token, userId: userId);
}

