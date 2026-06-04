import 'package:freezed_annotation/freezed_annotation.dart';
import 'auth_token.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    String? status, // e.g. "mfa_required"
    AuthToken? access,
    AuthToken? refresh,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
