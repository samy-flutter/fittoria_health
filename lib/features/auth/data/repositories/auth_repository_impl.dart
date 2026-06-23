import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/login_response.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/preferences_helper.dart';
import '../../../../routes/app_router.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/logging/app_logger.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;
  final PreferencesHelper _prefs;
  final AuthStatusNotifier _authStatusNotifier;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._secureStorage,
    this._prefs,
    this._authStatusNotifier,
  );

  @override
  Future<LoginResponse> login({
    required String identifier,
    required String password,
  }) async {
    final response = await _remoteDataSource.login(
      identifier: identifier,
      password: password,
    );

    if (response.status == 'mfa_required') {
      return response;
    }

    final accessToken = response.access?.token;
    final refreshToken = response.refresh?.token;
    final sessionId = response.refresh?.sessionId;
    final accessTokenExpiresAt = response.access?.expires;
    final refreshTokenExpiresAt = response.refresh?.expires;

    if (accessToken != null && refreshToken != null && sessionId != null && accessTokenExpiresAt != null && refreshTokenExpiresAt != null) {
      // Save credentials in secure storage
      await _secureStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        sessionId: sessionId,
        accessTokenExpiresAt: accessTokenExpiresAt,
        refreshTokenExpiresAt: refreshTokenExpiresAt,
      );

      // Cache details and flag login status
      await _prefs.setIsLoggedIn(true);

      // Trigger GoRouter refresh
      _authStatusNotifier.updateLoginState(true);
    } else {
      throw Exception('Invalid tokens received from server');
    }

    return response;
  }

  @override
  Future<void> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    await _remoteDataSource.register(
      fullName: fullName,
      phone: phone,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    await _secureStorage.clearAll();
    await _prefs.setIsLoggedIn(false);
    _authStatusNotifier.updateLoginState(false);
  }

  @override
  Future<void> forgotPassword(String identifier) async {
    await _remoteDataSource.forgotPassword(identifier);
  }

  @override
  Future<bool> checkAuthStatus() async {
    try {
      final isLoggedIn = _prefs.isLoggedIn();
      if (!isLoggedIn) return false;

      final accessToken = await _secureStorage.getAccessToken();
      final refreshToken = await _secureStorage.getRefreshToken();
      final sessionId = await _secureStorage.getSessionId();
      final accessTokenExpiresAtStr = await _secureStorage.getAccessTokenExpiresAt();
      final refreshTokenExpiresAtStr = await _secureStorage.getRefreshTokenExpiresAt();

      if (accessToken == null || refreshToken == null || sessionId == null) {
        await _handleLocalLogout();
        return false;
      }

      // 1. Check refresh token expiration
      if (refreshTokenExpiresAtStr != null) {
        final refreshExpiresDate = DateTime.parse(refreshTokenExpiresAtStr).toUtc();
        if (DateTime.now().toUtc().isAfter(refreshExpiresDate)) {
          await _handleLocalLogout();
          return false;
        }
      }

      // 2. Check access token expiration (with 30-second buffer)
      bool requiresRefresh = false;
      if (accessTokenExpiresAtStr != null) {
        final accessExpiresDate = DateTime.parse(accessTokenExpiresAtStr).toUtc();
        if (DateTime.now().toUtc().add(const Duration(seconds: 30)).isAfter(accessExpiresDate)) {
          requiresRefresh = true;
        }
      } else {
        // If we somehow don't have expiration metadata, assume it needs refresh to be safe
        requiresRefresh = true;
      }

      if (requiresRefresh) {
        try {
          final refreshDio = Dio(BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ));
          
          final response = await refreshDio.post(
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
            await _secureStorage.updateTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
              accessTokenExpiresAt: newAccessExpiresAt,
              refreshTokenExpiresAt: newRefreshExpiresAt,
            );
            return true;
          } else {
            await _handleLocalLogout();
            return false;
          }
        } catch (e) {
          // If refresh API call fails completely, force logout
          AppLogger.e('Startup token refresh failed', e.toString());
          await _handleLocalLogout();
          return false;
        }
      }

      return true;
    } catch (e) {
      // General error during check
      await _handleLocalLogout();
      return false;
    }
  }

  Future<void> _handleLocalLogout() async {
    await _secureStorage.clearAll().catchError((_) {});
    await _prefs.setIsLoggedIn(false);
    _authStatusNotifier.updateLoginState(false);
  }
}
