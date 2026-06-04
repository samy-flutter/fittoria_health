abstract class AuthEvent {
  const AuthEvent();
}

class LoginSubmitted extends AuthEvent {
  final String identifier;
  final String password;

  const LoginSubmitted({
    required this.identifier,
    required this.password,
  });
}

class RegisterSubmitted extends AuthEvent {
  final String fullName;
  final String phone;
  final String email;
  final String password;

  const RegisterSubmitted({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
  });
}

class CheckSessionStatus extends AuthEvent {
  const CheckSessionStatus();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
