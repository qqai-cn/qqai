import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/translations/strings_enum.dart';
import '../constant/api_constant.dart';
import 'api_exceptions.dart';

enum RequestType { get, post, put, delete }

class ApiBaseClient {
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
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 90,
          ),
        );

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
      if (requestType == RequestType.get) {
        response = await _dio.get(
          url,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
            receiveTimeout: const Duration(seconds: _timeoutInSeconds),
            sendTimeout: const Duration(seconds: _timeoutInSeconds),
          ),
        );
      } else if (requestType == RequestType.post) {
        response = await _dio.post(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
            receiveTimeout: const Duration(seconds: _timeoutInSeconds),
            sendTimeout: const Duration(seconds: _timeoutInSeconds),
          ),
        );
      } else if (requestType == RequestType.put) {
        response = await _dio.put(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
            receiveTimeout: const Duration(seconds: _timeoutInSeconds),
            sendTimeout: const Duration(seconds: _timeoutInSeconds),
          ),
        );
      } else {
        response = await _dio.delete(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
            receiveTimeout: const Duration(seconds: _timeoutInSeconds),
            sendTimeout: const Duration(seconds: _timeoutInSeconds),
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
    } on SocketException {
      // No internet connection
      _handleSocketException(url: url, onError: null);
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
          sendTimeout: const Duration(seconds: _timeoutInSeconds),
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

  static void _handleError(String msg) {
    Logger().e('Error: $msg');
  }
}
