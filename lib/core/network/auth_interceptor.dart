import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../storage/preferences_helper.dart';
import 'api_endpoints.dart';
import '../logging/app_logger.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;
  final PreferencesHelper _prefs;
  final Dio _refreshDio; // Dedicated Dio client for token rotation to prevent circular loops
  bool _isRefreshing = false;
  final List<Map<String, dynamic>> _failedRequestsQueue = [];

  AuthInterceptor(this._secureStorage, this._prefs)
      : _refreshDio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Exclude auth-specific endpoints from adding authorization headers
    if (options.path.contains('/auth/mobile/login') ||
        options.path.contains('/auth/mobile/refresh') ||
        options.path.contains('/patient/register')) {
      return handler.next(options);
    }

    final accessToken = await _secureStorage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Exclude refresh endpoint itself to prevent infinite refresh cycles
    if (err.requestOptions.path.contains('/auth/mobile/refresh')) {
      await _handleLogout();
      return handler.next(err);
    }

    final RequestOptions requestOptions = err.requestOptions;

    if (_isRefreshing) {
      // Add failed request to queue while rotation is in progress
      _failedRequestsQueue.add({
        'options': requestOptions,
        'handler': handler,
      });
      return;
    }

    _isRefreshing = true;
    final refreshToken = await _secureStorage.getRefreshToken();
    final sessionId = await _secureStorage.getSessionId();

    if (refreshToken == null || sessionId == null) {
      _isRefreshing = false;
      await _handleLogout();
      return handler.next(err);
    }

    try {
      final response = await _refreshDio.post(
        ApiEndpoints.refresh,
        options: Options(headers: {
          'Authorization': 'Bearer $refreshToken',
        }),
        data: {
          'sessionId': sessionId,
          'refreshToken': refreshToken,
        },
      );

      final data = response.data?['data'];
      final newAccessToken = data?['access']?['token'];
      final newRefreshToken = data?['refresh']?['token'];
      final newAccessExpiresAt = data?['access']?['expiresAt'];
      final newRefreshExpiresAt = data?['refresh']?['expiresAt'];

      if (newAccessToken != null && newRefreshToken != null && newAccessExpiresAt != null && newRefreshExpiresAt != null) {
        // Save rotated tokens and expirations
        await _secureStorage.updateTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
          accessTokenExpiresAt: newAccessExpiresAt,
          refreshTokenExpiresAt: newRefreshExpiresAt,
        );

        // Retry the initial failed request
        requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final originalResponse = await _retryRequest(requestOptions);
        handler.resolve(originalResponse);

        // Process remaining queue items
        for (final queued in _failedRequestsQueue) {
          final qOpts = queued['options'] as RequestOptions;
          final qHandler = queued['handler'] as ErrorInterceptorHandler;
          qOpts.headers['Authorization'] = 'Bearer $newAccessToken';
          try {
            final qResponse = await _retryRequest(qOpts);
            qHandler.resolve(qResponse);
          } catch (qErr) {
            if (qErr is DioException) {
              qHandler.next(qErr);
            } else {
              qHandler.reject(
                DioException(
                  requestOptions: qOpts,
                  error: qErr,
                ),
              );
            }
          }
        }
        _failedRequestsQueue.clear();
      } else {
        throw DioException(
          requestOptions: requestOptions,
          message: 'Failed to parse rotated tokens.',
        );
      }
    } catch (e) {
      // Log out patient if refresh token fails or is expired
      AppLogger.e('Token refresh failed', e.toString());
      await _handleLogout();
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions options) {
    final dio = Dio(
      BaseOptions(
        baseUrl: options.baseUrl,
        headers: options.headers,
        method: options.method,
        queryParameters: options.queryParameters,
      ),
    );
    return dio.request(
      options.path,
      data: options.data,
    );
  }

  Future<void> _handleLogout() async {
    await _secureStorage.clearAll();
    await _prefs.setIsLoggedIn(false);
    // Note: Router redirection handles navigating to login screen when isLoggedIn changes to false
  }
}
