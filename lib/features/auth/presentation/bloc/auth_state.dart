import '../../data/models/login_response.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final LoginResponse loginResponse;

  const AuthAuthenticated(this.loginResponse);
}

class AuthMfaRequired extends AuthState {
  final String message;

  const AuthMfaRequired(this.message);
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

class RegisterSuccess extends AuthState {
  final String message;

  const RegisterSuccess(this.message);
}
