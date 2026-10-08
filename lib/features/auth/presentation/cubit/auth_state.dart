import '../../domain/entities/auth_session.dart';

enum AuthStatus { initial, submitting, success, failure }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.session,
  });

  final AuthStatus status;
  final String? errorMessage;
  final AuthSession? session;

  bool get isSubmitting => status == AuthStatus.submitting;
}
