import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_endpoints.dart';
import 'auth_interceptor.dart';
import '../logging/app_logger.dart';

/// Custom Dio interceptor that feeds structured logs through [AppLogger].
class _AppLogInterceptor extends Interceptor {
  final _timers = <String, DateTime>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final key = '${options.method}:${options.path}';
    _timers[key] = DateTime.now();

    // Generate cURL command
    var headerString = options.headers.entries
        .map((e) => '-H "${e.key}: ${e.value}"')
        .join(' ');
    var bodyString = '';
    if (options.method != 'GET' && options.data != null) {
      try {
        bodyString = "-d '${jsonEncode(options.data)}'";
      } catch (_) {
        bodyString = "-d '${options.data}'";
      }
    }
    final curlCommand = 'curl -X ${options.method} $headerString $bodyString "${options.uri}"';
    
    AppLogger.request(
      options.method,
      options.path,
      options.data is Map<String, dynamic> ? options.data as Map<String, dynamic> : null,
      curlCommand,
    );
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final key = '${response.requestOptions.method}:${response.requestOptions.path}';
    final ms = _timers.remove(key) != null
        ? DateTime.now().difference(_timers[key] ?? DateTime.now()).inMilliseconds
        : null;
    AppLogger.response(
      response.statusCode ?? 0, 
      response.requestOptions.path, 
      ms,
      response.data,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final key = '${err.requestOptions.method}:${err.requestOptions.path}';
    _timers.remove(key);
    AppLogger.e(
      'API Error [${err.response?.statusCode ?? "–"}] ${err.requestOptions.path}',
      'Message: ${err.message}\nResponse Data: ${err.response?.data}',
    );
    handler.next(err);
  }
}



class DioClient {
  final Dio _dio;

  DioClient(AuthInterceptor authInterceptor)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(authInterceptor);
    if (kDebugMode) {
      _dio.interceptors.add(_AppLogInterceptor());
    }
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
