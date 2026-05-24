import 'package:flutter/material.dart';

/// 无 [BuildContext] 时展示全局提示（如 401 未登录）。
class ApiMessenger {
  ApiMessenger._();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static DateTime? _lastUnauthorizedHintAt;

  static String messageFromBusinessBody(dynamic data) {
    if (data is! Map) return '账户未登录，请先登录';
    final msg = data['msg'] ?? data['message'];
    if (msg is String && msg.trim().isNotEmpty) {
      return msg.trim();
    }
    return '账户未登录，请先登录';
  }

  static int? businessCode(dynamic data) {
    if (data is! Map) return null;
    final code = data['code'];
    if (code is int) return code;
    if (code is String) return int.tryParse(code);
    return null;
  }

  /// 展示未登录提示；短时间重复调用只弹一次。
  static void showUnauthorized(String message) {
    final now = DateTime.now();
    if (_lastUnauthorizedHintAt != null &&
        now.difference(_lastUnauthorizedHintAt!) <
            const Duration(seconds: 3)) {
      return;
    }
    _lastUnauthorizedHintAt = now;

    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
