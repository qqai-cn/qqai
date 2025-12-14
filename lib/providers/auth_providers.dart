import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    final token = MySharedPref.getFcmToken(); // 这里可以改为 getAuthToken
    final isAuthenticated = token != null && token.isNotEmpty;
    
    return AuthState(
      isAuthenticated: isAuthenticated,
      token: token,
    );
  }

  // 登录
  Future<void> login(String username, String password) async {
    // TODO: 实现登录逻辑
    // 1. 调用登录 API
    // 2. 保存 token 到本地
    // 3. 更新状态
    
    // 示例：
    // final response = await loginApi(username, password);
    // await MySharedPref.setAuthToken(response.token);
    // state = state.copyWith(
    //   isAuthenticated: true,
    //   userId: response.userId,
    //   token: response.token,
    //   username: username,
    // );
    
    // 临时示例（实际应该从 API 获取）
    state = state.copyWith(
      isAuthenticated: true,
      username: username,
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  // 登出
  Future<void> logout() async {
    // TODO: 实现登出逻辑
    // 1. 清除本地 token
    // 2. 调用登出 API（可选）
    // 3. 更新状态
    
    // await MySharedPref.clearAuthToken();
    state = const AuthState(isAuthenticated: false);
  }

  // 检查认证状态
  bool checkAuth() {
    return state.isAuthenticated;
  }
}

