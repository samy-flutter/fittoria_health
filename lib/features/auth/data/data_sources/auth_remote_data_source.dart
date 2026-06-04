import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login({
    required String identifier,
    required String password,
  });

  Future<void> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<LoginResponse> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        ApiEndpoints.login,
        data: {
          'identifier': identifier,
          'password': password,
          'asPatient': true,
        },
      );
      
      final data = response.data?['data'];
      if (data != null) {
        return LoginResponse.fromJson(data);
      } else {
        throw ApiException(message: 'Login failed. Invalid response structure from server.');
      }
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      await _client.post(
        ApiEndpoints.register,
        data: {
          'full_name': fullName,
          'phone': phone,
          'email': email,
          'password': password,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _client.post(ApiEndpoints.logout);
    } on DioException catch (_) {
      // If logging out fails on network side, we swallow the error since the client must still log out locally.
    }
  }
}
