import '../../data/models/login_response.dart';

abstract class AuthRepository {
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

  Future<bool> checkAuthStatus();
}
