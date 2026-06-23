import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/exception_handler.dart';
import '../../domain/repositories/auth_repository.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit(this._authRepository) : super(ForgotPasswordInitial());

  Future<void> submitForgotPassword(String identifier) async {
    final trimmedIdentifier = identifier.trim();

    if (trimmedIdentifier.isEmpty) {
      emit(const ForgotPasswordError('Email or phone number cannot be empty.'));
      return;
    }

    emit(ForgotPasswordLoading());

    try {
      await _authRepository.forgotPassword(trimmedIdentifier);
      emit(const ForgotPasswordSuccess('If an account exists with this identifier, you will receive a password reset link.'));
    } catch (e) {
      emit(ForgotPasswordError(ExceptionHandler.handle(e).message));
    }
  }
}
