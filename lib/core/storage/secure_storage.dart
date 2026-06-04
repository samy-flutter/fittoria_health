import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage(this._storage);

  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keySessionId = 'session_id';

  static const String _keyAccessTokenExpiresAt = 'access_token_expires_at';
  static const String _keyRefreshTokenExpiresAt = 'refresh_token_expires_at';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String sessionId,
    required String accessTokenExpiresAt,
    required String refreshTokenExpiresAt,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
    await _storage.write(key: _keySessionId, value: sessionId);
    await _storage.write(key: _keyAccessTokenExpiresAt, value: accessTokenExpiresAt);
    await _storage.write(key: _keyRefreshTokenExpiresAt, value: refreshTokenExpiresAt);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  Future<String?> getSessionId() async {
    return await _storage.read(key: _keySessionId);
  }

  Future<String?> getAccessTokenExpiresAt() async {
    return await _storage.read(key: _keyAccessTokenExpiresAt);
  }

  Future<String?> getRefreshTokenExpiresAt() async {
    return await _storage.read(key: _keyRefreshTokenExpiresAt);
  }

  Future<void> updateAccessToken(String newAccessToken) async {
    await _storage.write(key: _keyAccessToken, value: newAccessToken);
  }

  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
    required String accessTokenExpiresAt,
    required String refreshTokenExpiresAt,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
    await _storage.write(key: _keyAccessTokenExpiresAt, value: accessTokenExpiresAt);
    await _storage.write(key: _keyRefreshTokenExpiresAt, value: refreshTokenExpiresAt);
  }

  Future<void> clearAll() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keySessionId);
    await _storage.delete(key: _keyAccessTokenExpiresAt);
    await _storage.delete(key: _keyRefreshTokenExpiresAt);
  }
}
