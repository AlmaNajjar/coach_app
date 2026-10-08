import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/auth_exception.dart';
import '../../domain/use_cases/login_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._loginUseCase) : super(const AuthState());

  final LoginUseCase _loginUseCase;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (state.isSubmitting) return;
    emit(const AuthState(status: AuthStatus.submitting));

    try {
      final session = await _loginUseCase(
        username: username,
        password: password,
      );
      emit(AuthState(status: AuthStatus.success, session: session));
    } on AuthException catch (error) {
      emit(AuthState(status: AuthStatus.failure, errorMessage: error.message));
    } on Exception catch (error, stackTrace) {
      debugPrint('Unexpected login error: $error\n$stackTrace');
      emit(
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'Unable to sign in right now. Please try again.',
        ),
      );
    }
  }
}
