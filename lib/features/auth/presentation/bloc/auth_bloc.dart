import '../../../../core/error/exception_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<CheckSessionStatus>(_onCheckSessionStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final identifier = event.identifier.trim();
    final password = event.password;

    if (identifier.isEmpty || password.isEmpty) {
      emit(const AuthError('Phone number/email and password cannot be empty.'));
      return;
    }

    emit(AuthLoading());

    try {
      final response = await _authRepository.login(
        identifier: identifier,
        password: password,
      );

      if (response.status == 'mfa_required') {
        emit(const AuthMfaRequired('MFA is required. Please check your authenticator device.'));
      } else {
        emit(AuthAuthenticated(response));
      }
    } catch (e) {
      emit(AuthError(ExceptionHandler.handle(e).message));
    }
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final fullName = event.fullName.trim();
    final phone = event.phone.trim();
    final email = event.email.trim();
    final password = event.password;

    if (fullName.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
      emit(const AuthError('All registration fields are required.'));
      return;
    }

    if (phone.length < 10) {
      emit(const AuthError('Mobile number must be a valid 10-digit number.'));
      return;
    }

    if (password.length < 6) {
      emit(const AuthError('Password must be a minimum of 6 characters.'));
      return;
    }

    emit(AuthLoading());

    try {
      await _authRepository.register(
        fullName: fullName,
        phone: phone,
        email: email,
        password: password,
      );
      
      emit(const RegisterSuccess('Registration successful! Please sign in.'));
    } catch (e) {
      emit(AuthError(ExceptionHandler.handle(e).message));
    }
  }

  Future<void> _onCheckSessionStatus(
    CheckSessionStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isLoggedIn = await _authRepository.checkAuthStatus();
      if (isLoggedIn) {
        // Safe check passed
        emit(AuthInitial());
      } else {
        emit(AuthInitial());
      }
    } catch (_) {
      emit(AuthInitial());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(ExceptionHandler.handle(e).message));
    }
  }
}
