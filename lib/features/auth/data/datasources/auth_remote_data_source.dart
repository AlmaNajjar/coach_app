import 'package:coach_app/core/networking/api_constants.dart';
import 'package:dio/dio.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    final data = response.data;
    if (data is! Map) {
      throw const FormatException('Login response must be a JSON object.');
    }
    return LoginResponse.fromJson(Map<String, dynamic>.from(data));
  }
}
