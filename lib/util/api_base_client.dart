import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/translations/strings_enum.dart';
import '../constant/api_constant.dart';
import 'api_error_message.dart';
import 'api_exceptions.dart';
import 'api_messenger.dart';
import 'my_shared_pref.dart';

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

  static bool _hasRefreshToken() {
    final token = MySharedPref.getRefreshToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> _rejectUnauthorized(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
    String message, {
    bool logout = true,
  }) async {
    ApiMessenger.showUnauthorized(message);
    if (logout && _onLogout != null) {
      await _onLogout!();
    }
    handler.reject(
      DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: message,
      ),
    );
  }

  static Future<void> _rejectUnauthorizedError(
    DioException error,
    ErrorInterceptorHandler handler,
    String message, {
    bool logout = true,
  }) async {
    ApiMessenger.showUnauthorized(message);
    if (logout && _onLogout != null) {
      await _onLogout!();
    }
    handler.reject(
      DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        type: DioExceptionType.badResponse,
        message: message,
      ),
    );
  }

  static Future<Response<dynamic>> _handle401AndRetry(
    RequestOptions requestOptions,
  ) async {
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

  static final Dio _dio = _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstant.BASE_URL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: false,
          requestBody: false,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // multipart 须由浏览器/Dio 自动带 boundary；全局 application/json 会导致 Web 上传 XHR onError
          if (options.data is FormData) {
            options.headers.remove(Headers.contentTypeHeader);
          }
          // 每次请求都添加最新的 Authorization 头
          if (_authorization != null) {
            options.headers['Authorization'] = _authorization;
          }
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          final data = response.data;
          if (ApiMessenger.businessCode(data) == 401 &&
              response.requestOptions.path != ApiConstant.REFRESH_TOKEN) {
            final message = ApiMessenger.messageFromBusinessBody(data);
            if (_hasRefreshToken()) {
              try {
                final retryResponse = await _handle401AndRetry(
                  response.requestOptions,
                );
                final retryData = retryResponse.data;
                if (ApiMessenger.businessCode(retryData) == 401) {
                  await _rejectUnauthorized(response, handler, message);
                  return;
                }
                return handler.resolve(retryResponse);
              } catch (e) {
                await _rejectUnauthorized(response, handler, message);
                return;
              }
            } else {
              await _rejectUnauthorized(
                response,
                handler,
                message,
                logout: false,
              );
              return;
            }
          }
          return handler.next(response);
        },
        onError: (error, handler) async {
          final isHttp401 = error.response?.statusCode == 401;
          final data = error.response?.data;
          final isBiz401 = ApiMessenger.businessCode(data) == 401;
          if ((isHttp401 || isBiz401) &&
              error.requestOptions.path != ApiConstant.REFRESH_TOKEN) {
            final message = ApiMessenger.messageFromBusinessBody(data);
            if (_hasRefreshToken()) {
              try {
                final retryResponse = await _handle401AndRetry(
                  error.requestOptions,
                );
                return handler.resolve(retryResponse);
              } catch (e) {
                await _rejectUnauthorizedError(error, handler, message);
                return;
              }
            } else {
              await _rejectUnauthorizedError(
                error,
                handler,
                message,
                logout: false,
              );
              return;
            }
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    // 复制请求头并确保使用最新的 Authorization
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    if (_authorization != null) {
      headers['Authorization'] = _authorization;
    }

    final options = Options(method: requestOptions.method, headers: headers);

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  static String? _authorization;

  /// Set global Authorization header (for example, "Bearer token").
  static void setAuthorization(String? value) {
    _authorization = value;
  }

  // request timeout (default 100 seconds)
  static const int _timeoutInSeconds = 100;
  // file upload timeout (1 hour, supports large files up to 1GB)
  static const int _uploadTimeoutInSeconds = 3600;

  /// dio getter (used for testing)
  static Dio get dio => _dio;

  /// perform safe api request
  static Future<Response> safeApiCall(
    String url,
    RequestType requestType, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    int? timeoutInSeconds,
  }) async {
    try {
      late Response response;
      final mergedHeaders = <String, dynamic>{
        ..._dio.options.headers,
        if (_authorization != null) 'Authorization': _authorization,
        ...?headers,
      };
      if (data is FormData) {
        mergedHeaders.remove(Headers.contentTypeHeader);
      }
      final timeout = Duration(seconds: timeoutInSeconds ?? _timeoutInSeconds);
      // Web 的 XHR 不支持 sendTimeout；大文件上传设 sendTimeout 可能直接 connection error
      final bool hasData = data != null;
      final Duration? sendTimeout = hasData && !kIsWeb ? timeout : null;
      if (requestType == RequestType.get) {
        response = await _dio.get(
          url,
          queryParameters: queryParameters,
          options: Options(headers: mergedHeaders, receiveTimeout: timeout),
        );
      } else if (requestType == RequestType.post) {
        response = await _dio.post(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: mergedHeaders,
            receiveTimeout: timeout,
            sendTimeout: sendTimeout,
          ),
        );
      } else if (requestType == RequestType.put) {
        response = await _dio.put(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: mergedHeaders,
            receiveTimeout: timeout,
            sendTimeout: sendTimeout,
          ),
        );
      } else {
        response = await _dio.delete(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: mergedHeaders,
            receiveTimeout: timeout,
            sendTimeout: sendTimeout,
          ),
        );
      }
      // 3) return response (api done successfully)
      return response;
    } on DioException catch (error) {
      final exception = _toApiException(error: error, url: url);
      Logger().e('DioException [$url]: $error');
      throw exception;
    } on TimeoutException {
      final exception = ApiException(
        message: Strings.serverNotResponding,
        url: url,
      );
      Logger().e('TimeoutException [$url]');
      throw exception;
    } catch (error, stackTrace) {
      Logger().e(stackTrace);
      throw ApiException(message: error.toString(), url: url);
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

  static ApiException _toApiException({
    required DioException error,
    required String url,
  }) {
    if (ApiErrorMessage.userMessage(error) == ApiErrorMessage.networkUnavailable) {
      return ApiException(
        message: ApiErrorMessage.networkUnavailable,
        url: url,
      );
    }

    if (error.response?.statusCode == 404) {
      return ApiException(
        message: Strings.urlNotFound,
        url: url,
        statusCode: 404,
      );
    }

    if (error.response?.statusCode == 500) {
      return ApiException(
        message: Strings.serverError,
        url: url,
        statusCode: 500,
        response: error.response,
      );
    }

    return ApiException(
      url: url,
      message: error.message ?? Strings.someThingWentWorng,
      response: error.response,
      statusCode: error.response?.statusCode,
    );
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
      final multipartFile = await _multipartFileFromXFile(file);

      final fields = <String, dynamic>{'file': multipartFile};
      if (directory != null) {
        fields['directory'] = directory;
      }
      final formData = FormData.fromMap(fields);

      final response = await safeApiCall(
        ApiConstant.FILE_UPLOAD,
        RequestType.post,
        data: formData,
        timeoutInSeconds: _uploadTimeoutInSeconds,
      );

      return response.data['data'] as String;
    } catch (error) {
      Logger().e('File upload error: $error');
      rethrow;
    }
  }

  static Future<MultipartFile> _multipartFileFromXFile(XFile file) async {
    final filename = file.name.isNotEmpty ? file.name : 'upload';
    try {
      return MultipartFile.fromStream(
        () => file.openRead(),
        await file.length(),
        filename: filename,
      );
    } catch (_) {
      // Browser-backed files can still require a byte fallback.
      // Keep this scoped to the upload part instead of retaining bytes in state.
      final bytes = await file.readAsBytes();
      return MultipartFile.fromBytes(bytes, filename: filename);
    }
  }

  static void _handleError(String msg) {
    Logger().e('Error: $msg');
  }
}
