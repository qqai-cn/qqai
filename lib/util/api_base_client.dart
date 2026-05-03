import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/translations/strings_enum.dart';
import '../constant/api_constant.dart';
import 'api_exceptions.dart';

enum RequestType { get, post, put, delete }

class ApiBaseClient {
  static bool _isRefreshing = false;
  static final List<Completer<void>> _refreshCompleters = [];
  static Future<void> Function()? _onRefreshToken;
  static Future<void> Function()? _onLogout;

  static void setRefreshCallbacks({
    required Future<void> Function() onRefreshToken,
    required Future<void> Function() onLogout,
  }) {
    _onRefreshToken = onRefreshToken;
    _onLogout = onLogout;
  }

  static Future<Response<dynamic>> _handle401AndRetry(RequestOptions requestOptions) async {
    if (_isRefreshing) {
      // 已经在刷新中，等待刷新完成后重试
      final completer = Completer<void>();
      _refreshCompleters.add(completer);
      await completer.future;
      return await _retry(requestOptions);
    }

    _isRefreshing = true;
    try {
      // 尝试刷新令牌
      if (_onRefreshToken != null) {
        await _onRefreshToken!();
      }
      // 通知所有等待的请求
      for (final completer in _refreshCompleters) {
        completer.complete();
      }
      _refreshCompleters.clear();
      // 重试原请求
      return await _retry(requestOptions);
    } catch (refreshError) {
      // 刷新失败，清除所有等待并拒绝
      for (final completer in _refreshCompleters) {
        completer.completeError(refreshError);
      }
      _refreshCompleters.clear();
      // 登出
      if (_onLogout != null) {
        await _onLogout!();
      }
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }

  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: ApiConstant.BASE_URL,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        )
        ..interceptors.add(
          PrettyDioLogger(
            requestHeader: false,
            requestBody: false,
            responseBody: false,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 90,
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              // 每次请求都添加最新的 Authorization 头
              if (_authorization != null) {
                options.headers['Authorization'] = _authorization;
              }
              return handler.next(options);
            },
            onResponse: (response, handler) async {
              // 检查业务代码 401
              final data = response.data;
              if (data is Map && data['code'] == 401 && 
                  response.requestOptions.path != ApiConstant.REFRESH_TOKEN) {
                try {
                  // 处理业务代码 401
                  final retryResponse = await _handle401AndRetry(response.requestOptions);
                  return handler.resolve(retryResponse);
                } catch (e) {
                  // 如果刷新失败，直接返回原响应
                  return handler.next(response);
                }
              }
              return handler.next(response);
            },
            onError: (error, handler) async {
              // 检查 HTTP 状态码 401 且不是刷新令牌接口本身
              if (error.response?.statusCode == 401 && 
                  error.requestOptions.path != ApiConstant.REFRESH_TOKEN) {
                try {
                  final retryResponse = await _handle401AndRetry(error.requestOptions);
                  return handler.resolve(retryResponse);
                } catch (e) {
                  // 如果刷新失败，继续传播错误
                  return handler.next(error);
                }
              }
              return handler.next(error);
            },
          ),
        );

  static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    // 复制请求头并确保使用最新的 Authorization
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    if (_authorization != null) {
      headers['Authorization'] = _authorization;
    }
    
    final options = Options(
      method: requestOptions.method,
      headers: headers,
    );
    
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  static String? _authorization;

  /// Set global Authorization header (e.g. "Bearer <token>")
  static void setAuthorization(String? value) {
    _authorization = value;
  }

  // request timeout (default 10 seconds)
  static const int _timeoutInSeconds = 10;

  /// dio getter (used for testing)
  static Dio get dio => _dio;

  /// perform safe api request
  static Future<Response> safeApiCall(
    String url,
    RequestType requestType, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      late Response response;
      final mergedHeaders = <String, dynamic>{
        ...?_dio.options.headers,
        if (_authorization != null) 'Authorization': _authorization,
        ...?headers,
      };
      // Only set sendTimeout when there's data to send (avoids Web warning)
      final bool hasData = data != null;
      if (requestType == RequestType.get) {
        response = await _dio.get(
          url,
          queryParameters: queryParameters,
          options: Options(
            headers: mergedHeaders,
            receiveTimeout: const Duration(seconds: _timeoutInSeconds),
          ),
        );
      } else if (requestType == RequestType.post) {
        response = await _dio.post(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: mergedHeaders,
            receiveTimeout: const Duration(seconds: _timeoutInSeconds),
            sendTimeout: hasData ? const Duration(seconds: _timeoutInSeconds) : null,
          ),
        );
      } else if (requestType == RequestType.put) {
        response = await _dio.put(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: mergedHeaders,
            receiveTimeout: const Duration(seconds: _timeoutInSeconds),
            sendTimeout: hasData ? const Duration(seconds: _timeoutInSeconds) : null,
          ),
        );
      } else {
        response = await _dio.delete(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: mergedHeaders,
            receiveTimeout: const Duration(seconds: _timeoutInSeconds),
            sendTimeout: hasData ? const Duration(seconds: _timeoutInSeconds) : null,
          ),
        );
      }
      // 3) return response (api done successfully)
      return response;
    } on DioException catch (error) {
      // dio error (api reach the server but not performed successfully)
      _handleDioError(error: error, url: url, onError: null);
      rethrow;
    } on TimeoutException {
      // Api call went out of time
      _handleTimeoutException(url: url, onError: null);
      rethrow;
    } catch (error, stackTrace) {
      // print the line of code that throw unexpected exception
      Logger().e(stackTrace);
      // unexpected error for example (parsing json error)
      _handleUnexpectedException(url: url, onError: null, error: error);
      rethrow;
    }
  }

  /// download file
  static Future<void> download({
    required String url, // file url
    required String savePath, // where to save file
    Function(ApiException)? onError,
    Function(int value, int progress)? onReceiveProgress,
    required Function onSuccess,
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        options: Options(
          receiveTimeout: const Duration(seconds: _timeoutInSeconds),
          // No sendTimeout for download (no request body)
        ),
        onReceiveProgress: onReceiveProgress,
      );
      onSuccess();
    } catch (error) {
      var exception = ApiException(url: url, message: error.toString());
      onError?.call(exception) ?? _handleError(error.toString());
    }
  }

  /// handle unexpected error
  static void _handleUnexpectedException({
    Function(ApiException)? onError,
    required String url,
    required Object error,
  }) {
    if (onError != null) {
      onError(ApiException(message: error.toString(), url: url));
    } else {
      _handleError(error.toString());
    }
  }

  /// handle timeout exception
  static void _handleTimeoutException({
    Function(ApiException)? onError,
    required String url,
  }) {
    final message = Strings.serverNotResponding;
    if (onError != null) {
      onError(ApiException(message: message, url: url));
    } else {
      _handleError(message);
    }
  }

  /// handle timeout exception
  static void _handleSocketException({
    Function(ApiException)? onError,
    required String url,
  }) {
    final message = Strings.noInternetConnection;
    if (onError != null) {
      onError(ApiException(message: message, url: url));
    } else {
      _handleError(message);
    }
  }

  /// handle Dio error
  static void _handleDioError({
    required DioException error,
    Function(ApiException)? onError,
    required String url,
  }) {
    // no internet connection
    if (error.type == DioExceptionType.connectionError) {
      _handleSocketException(url: url, onError: onError);
      return;
    }

    // 404 error
    if (error.response?.statusCode == 404) {
      final message = Strings.urlNotFound;
      if (onError != null) {
        onError(ApiException(message: message, url: url, statusCode: 404));
        return;
      } else {
        _handleError(message);
        return;
      }
    }

    // no internet connection
    if (error.message != null &&
        error.message!.toLowerCase().contains('socket')) {
      final message = Strings.noInternetConnection;
      if (onError != null) {
        onError(ApiException(message: message, url: url));
        return;
      } else {
        _handleError(message);
        return;
      }
    }

    // check if the error is 500 (server problem)
    if (error.response?.statusCode == 500) {
      final message = Strings.serverError;
      var exception = ApiException(message: message, url: url, statusCode: 500);

      if (onError != null) {
        onError(exception);
        return;
      } else {
        handleApiError(exception);
        return;
      }
    }

    var exception = ApiException(
      url: url,
      message: error.message ?? 'Un Expected Api Error!',
      response: error.response,
      statusCode: error.response?.statusCode,
    );
    if (onError != null) {
      onError(exception);
      return;
    } else {
      handleApiError(exception);
      return;
    }
  }

  static void handleApiError(ApiException apiException) {
    String msg = apiException.toString();
    Logger().e('API Error: $msg');
  }

  static Future<String> uploadFile({
    required XFile file,
    String? directory,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final multipartFile = MultipartFile.fromBytes(
        bytes,
        filename: file.name,
      );
      
      final formData = FormData.fromMap({
        'file': multipartFile,
        if (directory != null) 'directory': directory,
      });
      
      final response = await safeApiCall(
        ApiConstant.FILE_UPLOAD,
        RequestType.post,
        data: formData,
      );
      
      return response.data['data'] as String;
    } catch (error) {
      Logger().e('File upload error: $error');
      rethrow;
    }
  }

  static void _handleError(String msg) {
    Logger().e('Error: $msg');
  }
}
