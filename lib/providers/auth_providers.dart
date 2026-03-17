import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/data/auth_api.dart';
import '../util/api_base_client.dart';
import '../util/my_shared_pref.dart';

part 'auth_providers.freezed.dart';
part 'auth_providers.g.dart';

// 认证状态 - 使用 Freezed 生成不可变类
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    String? userId,
    String? token,
    String? username,
  }) = _AuthState;
}

// 认证 Provider - 使用 Riverpod 3 代码生成
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // 从本地存储加载认证状态
    final token = MySharedPref.getAuthToken();
    final isAuthenticated = token != null && token.isNotEmpty;

    if (isAuthenticated) {
      ApiBaseClient.setAuthorization('Bearer $token');
    }

    return AuthState(
      isAuthenticated: isAuthenticated,
      token: token,
    );
  }

  // 登录
  Future<void> login(String username, String password) async {
    final resp = await loginApi(username: username, password: password);
    if (!ref.mounted) return;

    await MySharedPref.setAuthToken(resp.token);
    if (!ref.mounted) return;

    ApiBaseClient.setAuthorization('Bearer ${resp.token}');
    state = state.copyWith(
      isAuthenticated: true,
      userId: resp.userId,
      username: username,
      token: resp.token,
    );
  }

  // 登出
  Future<void> logout() async {
    await MySharedPref.clearAuthToken();
    if (!ref.mounted) return;
    ApiBaseClient.setAuthorization(null);
    state = const AuthState(isAuthenticated: false);
  }

  // 检查认证状态
  bool checkAuth() {
    return state.isAuthenticated;
  }
}

