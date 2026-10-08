import 'package:coach_app/core/helper/password_hash_service.dart';
import 'package:coach_app/core/networking/api_error_handler.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/auth_exception.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        LoginRequest(
          username: username,
          password: PasswordHashService.hashPassword(password),
        ),
      );
      final data = response.data;
      if (data == null || data.accessToken.trim().isEmpty) {
        throw AuthException(
          response.message.trim().isEmpty
              ? 'The server returned an incomplete login response.'
              : response.message,
        );
      }

      await _localDataSource.saveSession(data);
      return AuthSession(
        accessToken: data.accessToken,
        tokenType: data.tokenType,
        user: data.user.toJson(),
      );
    } on DioException catch (error) {
      throw AuthException(ErrorHandler.handle(error).failure.message);
    } on FormatException {
      throw const AuthException('The server returned an invalid login response.');
    } on TypeError {
      throw const AuthException('The server returned an invalid login response.');
    } on StateError catch (error) {
      throw AuthException(error.message.toString());
    }
  }
}
