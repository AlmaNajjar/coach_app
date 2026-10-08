import 'package:coach_app/core/di/dependency_injection.dart';
import 'package:coach_app/core/helper/app_session_maneger.dart';
import 'package:coach_app/core/helper/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'api_constants.dart';

class DioFactory {
  DioFactory._();

  static Dio? _dio;

  static Dio getDio() {
    const timeOut = Duration(seconds: 45);
    if (_dio == null) {
      _dio = Dio()
        ..options.baseUrl = ApiConstants.baseUrl
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut
        ..options.sendTimeout = timeOut
        ..options.headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        };

      _addDioInterceptors();
    }
    return _dio!;
  }

  static void _addDioInterceptors() {
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path != ApiConstants.login) {
            final token = await LocalStorage.getData('token');
            if (token != null && token.isNotEmpty) {
              final tokenType =
                  await LocalStorage.getData('token_type') ?? 'Bearer';
              options.headers['Authorization'] = '$tokenType $token';
            }
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              error.requestOptions.path != ApiConstants.login) {
            final token = await LocalStorage.getData('token');
            if (token != null && token.isNotEmpty) {
              await AppSessionManager.resetFromGlobalContext();
              final context =
                  getIt<GlobalKey<NavigatorState>>().currentContext;
              if (context != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Your session expired. Please sign in again.',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          }
          handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      _dio!.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: false,
          error: false,
          logPrint: (object) => debugPrint(object.toString()),
        ),
      );
    }
  }

  static void setTokenIntoHeader(String token, {String tokenType = 'Bearer'}) {
    _dio?.options.headers['Authorization'] = '$tokenType $token';
  }

  static void clearTokenFromHeader() {
    _dio?.options.headers.remove('Authorization');
  }
}
