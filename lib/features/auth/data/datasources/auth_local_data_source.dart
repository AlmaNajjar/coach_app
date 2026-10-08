import 'dart:convert';
import 'package:coach_app/core/helper/local_storage.dart';
import '../models/login_response.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveSession(LoginResponseData session);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl();

  @override
  Future<void> saveSession(LoginResponseData session) async {
    final savedUser = await LocalStorage.setData(
      'user_data',
      jsonEncode(session.user.toJson()),
    );
    final savedTokenType = await LocalStorage.setData(
      'token_type',
      session.tokenType,
    );
    final savedToken = await LocalStorage.setData(
      'token',
      session.accessToken,
    );

    if (!savedUser || !savedTokenType || !savedToken) {
      await LocalStorage.clearData('token');
      await LocalStorage.clearData('token_type');
      await LocalStorage.clearData('user_data');
      throw StateError('Unable to save the login session.');
    }
  }
}
