import 'package:coach_app/core/di/dependency_injection.dart';
import 'package:coach_app/core/helper/app_session_maneger.dart';
import 'package:coach_app/core/helper/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'api_constants.dart';

class DioFactory {
  // Private constructor to prevent instantiation
  DioFactory._();

  static Dio? _dio;

  /// Returns a configured Dio instance (Singleton)
  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 45);

    if (_dio == null) {
      _dio = Dio();
      _dio!
        ..options.baseUrl = ApiConstants.baseUrl
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut
        ..options.sendTimeout = timeOut;

      _addDioHeaders();
      _addDioInterceptors();
    }
    return _dio!;
  }

  /// Configures default headers for requests
  static void _addDioHeaders() {
    _dio!.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  /// Configures interceptors: Authorization & Logging
  static void _addDioInterceptors() {
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Retrieve token from shared preferences / local storage dynamically
          final token = await LocalStorage.getData('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final token = await LocalStorage.getData('token');
            if (token != null && token.isNotEmpty) {
              // 1. إعادة ضبط الجلسة أولاً وقراءة اسم المستخدم المحفوظ
              await AppSessionManager.resetFromGlobalContext();
              final savedUsername = await LocalStorage.getData(
                'Saved_username',
              );

              // 2. التوجيه لشاشة تسجيل الدخول وتمرير اسم المستخدم
              final context = getIt<GlobalKey<NavigatorState>>().currentContext;
              if (context != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'انتهت صلاحية الجلسة أو تم تسجيل الدخول من حساب آخر. يرجى تسجيل الدخول مجدداً.',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                // سيتم تفعيل التوجيه لشاشة تسجيل الدخول بمجرد إنشائها
                // Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            }
          }
          return handler.next(e);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
      ),
    );

    // Add logging interceptor in debug mode only
    if (kDebugMode) {
      _dio!.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (object) {
            debugPrint(object.toString());
          },
        ),
      );
    }
  }

  /// Helper method to manually set/refresh token header (e.g. immediately after login)
  static void setTokenIntoHeader(String token) {
    _dio?.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Helper method to manually clear token header (e.g. on logout)
  static void clearTokenFromHeader() {
    _dio?.options.headers.remove('Authorization');
  }
}
