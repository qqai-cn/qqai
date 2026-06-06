import 'package:dio/dio.dart';

import 'api_exceptions.dart';

/// 将异常转换为用户可见的简短提示。
class ApiErrorMessage {
  ApiErrorMessage._();

  static const String networkUnavailable = '网络异常，请稍后再试';

  static String userMessage(Object error) {
    if (error is ApiBusinessException) return error.message;
    if (error is ApiException) return error.toString();
    if (error is DioException && _isNetworkError(error)) {
      return networkUnavailable;
    }
    final text = error.toString();
    if (_looksLikeNetworkError(text)) return networkUnavailable;
    return text;
  }

  static bool _isNetworkError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return true;
      default:
        break;
    }
    return _looksLikeNetworkError(error.message ?? error.toString());
  }

  static bool _looksLikeNetworkError(String text) {
    final lower = text.toLowerCase();
    return lower.contains('no internet connection') ||
        lower.contains('connection error') ||
        lower.contains('xmlhttprequest') ||
        lower.contains('network layer') ||
        lower.contains('socket') ||
        lower.contains('failed host lookup') ||
        lower.contains('network is unreachable');
  }
}
