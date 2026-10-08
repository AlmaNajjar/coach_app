import 'dart:convert';
import 'package:dio/dio.dart';

/// Standard wrapper class that represents a failure (error) containing an error code and a message.
class Failure {
  final int statusCode;
  final String message;
  final List<String> suggestions;
  Failure({
    required this.statusCode,
    required this.message,
    this.suggestions = const [],
  });

  /// Factory constructor to parse custom error messages returned from the backend server
  factory Failure.fromResponse(Response response) {
    List<String>? suggestionsList;
    Map? dataMap;

    if (response.data != null) {
      if (response.data is Map) {
        dataMap = response.data as Map;
      } else if (response.data is String) {
        try {
          final decoded = jsonDecode(response.data.toString());
          if (decoded is Map) {
            dataMap = decoded;
          }
        } catch (_) {}
      }
    }

    // 🎯 قراءة الاقتراحات المباشرة والصريحة من data -> suggestions
    if (dataMap != null) {
      if (dataMap.containsKey('data') && dataMap['data'] is Map) {
        final innerData = dataMap['data'] as Map;
        if (innerData.containsKey('suggestions') &&
            innerData['suggestions'] is List) {
          suggestionsList = (innerData['suggestions'] as List)
              .map((e) => e.toString())
              .toList();
        }
      } else if (dataMap.containsKey('suggestions') &&
          dataMap['suggestions'] is List) {
        suggestionsList = (dataMap['suggestions'] as List)
            .map((e) => e.toString())
            .toList();
      }
    }

    int code = response.statusCode ?? ResponseCode.defaultError;
    String msg = ResponseMessage.defaultError;

    if (code >= 500) {
      msg = ResponseMessage.internalServerError;
    }

    try {
      if (dataMap != null) {
        final data = dataMap;

        // 1. Try to parse "message"
        if (data.containsKey('message') &&
            data['message'] != null &&
            data['message'].toString().trim().isNotEmpty) {
          msg = data['message'].toString();
        }
        // 2. Try to parse "status_message"
        else if (data.containsKey('status_message') &&
            data['status_message'] != null &&
            data['status_message'].toString().trim().isNotEmpty) {
          msg = data['status_message'].toString();
        }
        // 3. Try to parse "error"
        else if (data.containsKey('error') &&
            data['error'] != null &&
            data['error'].toString().trim().isNotEmpty) {
          msg = data['error'].toString();
        }
        // 4. Try to parse validation errors map "errors": {"email": ["Email already exists"]}
        else if (data.containsKey('errors') && data['errors'] is Map) {
          final errorsMap = data['errors'] as Map;
          final List<String> errorList = [];
          errorsMap.forEach((key, value) {
            if (value is List) {
              errorList.addAll(value.map((e) => e.toString()));
            } else {
              errorList.add(value.toString());
            }
          });
          if (errorList.isNotEmpty) {
            msg = errorList.join('\n');
          }
        }
      } else if (response.data is String &&
          response.data.toString().trim().isNotEmpty) {
        final String rawData = response.data.toString().trim();
        final String lowerData = rawData.toLowerCase();

        // Detect HTML structures or server crash signature texts
        if (lowerData.startsWith('<!doctype') ||
            lowerData.startsWith('<html') ||
            lowerData.contains('<body') ||
            lowerData.contains('</html>') ||
            lowerData.contains('<title>500') ||
            lowerData.contains('internal server error')) {
          if (code >= 500) {
            msg = ResponseMessage.internalServerError;
          } else if (code == 404) {
            msg = ResponseMessage.notFound;
          } else {
            msg = ResponseMessage.defaultError;
          }
        } else {
          msg = rawData;
        }
      } else if (response.statusMessage != null &&
          response.statusMessage!.isNotEmpty) {
        msg = response.statusMessage!;
      }
    } catch (_) {
      msg = ResponseMessage.defaultError;
    }

    return Failure(
      statusCode: code,
      message: ApiTranslator.translate(msg),
      suggestions: suggestionsList ?? const [],
    );
  }
}

/// Translates common backend messages (both success and error) into clear Arabic messages
class ApiTranslator {
  ApiTranslator._();

  static String translate(String message) {
    final cleanMessage = message.trim().toLowerCase();

    // 1. Success messages
    if (cleanMessage.contains("logged in successfully") ||
        cleanMessage.contains("login successful")) {
      return "تم تسجيل الدخول بنجاح.";
    }
    if (cleanMessage.contains("logged out successfully") ||
        cleanMessage.contains("logout successful")) {
      return "تم تسجيل الخروج بنجاح.";
    }
    if (cleanMessage.contains("password changed successfully") ||
        cleanMessage.contains("password change successful")) {
      return "تم تغيير كلمة المرور بنجاح.";
    }
    if (cleanMessage.contains("profile retrieved successfully") ||
        cleanMessage.contains("profile retrieve successful")) {
      return "تم استرجاع الملف الشخصي بنجاح.";
    }

    // 2. Failure/Validation messages
    if (cleanMessage.contains("invalid credentials") ||
        cleanMessage.contains("credentials do not match")) {
      return "اسم المستخدم أو كلمة المرور غير صحيحة.";
    }
    if (cleanMessage.contains("unauthenticated") ||
        cleanMessage.contains("unauthorized")) {
      return "غير مصرح لك بالوصول، يرجى تسجيل الدخول مجدداً.";
    }
    if (cleanMessage.contains("inactive") ||
        cleanMessage.contains("not active") ||
        cleanMessage.contains("disabled")) {
      return "حساب المستخدم غير نشط أو غير مفعل، يرجى مراجعة الإدارة.";
    }
    if (cleanMessage.contains("username field is required") ||
        cleanMessage.contains("username is required")) {
      return "حقل اسم المستخدم مطلوب.";
    }
    if (cleanMessage.contains("password field is required") ||
        cleanMessage.contains("password is required")) {
      return "حقل كلمة المرور مطلوب.";
    }
    if (cleanMessage.contains("current password") &&
        (cleanMessage.contains("incorrect") ||
            cleanMessage.contains("not matching") ||
            cleanMessage.contains("match") ||
            cleanMessage.contains("wrong"))) {
      return "كلمة المرور الحالية غير مطابقة.";
    }
    if (cleanMessage.contains("new password must be at least") ||
        cleanMessage.contains("new_password must be")) {
      return "كلمة المرور الجديدة يجب ألا تقل عن 8 أحرف.";
    }
    if (cleanMessage.contains("password confirmation does not match") ||
        cleanMessage.contains("confirmation does not match")) {
      return "تأكيد كلمة المرور الجديدة غير متطابق.";
    }
    if (cleanMessage.contains("too many login attempts")) {
      return "محاولات تسجيل دخول كثيرة جداً، يرجى المحاولة لاحقاً.";
    }
    if (cleanMessage.contains("email already exists") ||
        cleanMessage.contains("email has already been taken")) {
      return "البريد الإلكتروني مستخدم بالفعل.";
    }
    if (cleanMessage.contains("username already exists") ||
        cleanMessage.contains("username has already been taken")) {
      return "اسم المستخدم مستخدم بالفعل.";
    }

    return message;
  }
}

/// Global Error Handler to parse DioExceptions and normal Exceptions into a [Failure]
class ErrorHandler implements Exception {
  late final Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleDioError(error);
    } else {
      failure = DataSource.defaultError.getFailure();
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.connectTimeout.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.sendTimeout.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.receiveTimeout.getFailure();
      case DioExceptionType.badResponse:
        if (error.response != null) {
          return Failure.fromResponse(error.response!);
        } else {
          return DataSource.defaultError.getFailure();
        }
      case DioExceptionType.cancel:
        return DataSource.cancel.getFailure();
      case DioExceptionType.connectionError:
        return DataSource.noInternetConnection.getFailure();
      case DioExceptionType.badCertificate:
        return DataSource.badCertificate.getFailure();
      case DioExceptionType.unknown:
      default:
        return DataSource.defaultError.getFailure();
    }
  }
}

/// Enum representing the network status or datasource state
enum DataSource {
  success,
  noContent,
  badRequest,
  forbidden,
  unauthorized,
  notFound,
  internalServerError,
  connectTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  badCertificate,
  defaultError,
}

/// Status codes representing different HTTP response scenarios and network errors
class ResponseCode {
  static const int success = 200; // Success with content
  static const int noContent = 201; // Success with no content
  static const int badRequest = 400; // Server rejected request (validation etc)
  static const int unauthorized = 401; // Unauthorized user
  static const int forbidden = 403; // Access forbidden
  static const int notFound = 404; // Resource not found
  static const int internalServerError = 500; // Crash in server side

  // Local connection status codes
  static const int connectTimeout = -1;
  static const int cancel = -2;
  static const int receiveTimeout = -3;
  static const int sendTimeout = -4;
  static const int cacheError = -5;
  static const int noInternetConnection = -6;
  static const int badCertificate = -7;
  static const int defaultError = -8;
}

/// Clean user-friendly error messages
class ResponseMessage {
  static const String success = "تمت العملية بنجاح.";
  static const String noContent = "تمت العملية، لا يوجد محتوى لعرضه.";
  static const String badRequest = "طلب غير صالح، يرجى المحاولة لاحقاً.";
  static const String unauthorized =
      "غير مصرح لك بالوصول، يرجى تسجيل الدخول مجدداً.";
  static const String forbidden = "الوصول محظور، ليس لديك الصلاحية.";
  static const String notFound = "الصفحة أو الرابط غير موجود.";
  static const String internalServerError =
      "حدث خطأ في الخادم، يرجى المحاولة لاحقاً.";

  // Local connection messages
  static const String connectTimeout =
      "انتهت مهلة الاتصال بالخادم، يرجى إعادة المحاولة.";
  static const String cancel = "تم إلغاء الطلب، يرجى المحاولة لاحقاً.";
  static const String receiveTimeout = "انتهت مهلة استقبال البيانات من الخادم.";
  static const String sendTimeout = "انتهت مهلة إرسال البيانات إلى الخادم.";
  static const String cacheError = "حدث خطأ أثناء تحميل البيانات المحلية.";
  static const String noInternetConnection = "يرجى التحقق من اتصالك بالإنترنت.";
  static const String badCertificate = "خطأ في شهادة الأمان الخاصة بالاتصال.";
  static const String defaultError = "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً.";
}

/// Extension mapping DataSource enum to Failure object
extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.success:
        return Failure(
          statusCode: ResponseCode.success,
          message: ResponseMessage.success,
        );
      case DataSource.noContent:
        return Failure(
          statusCode: ResponseCode.noContent,
          message: ResponseMessage.noContent,
        );
      case DataSource.badRequest:
        return Failure(
          statusCode: ResponseCode.badRequest,
          message: ResponseMessage.badRequest,
        );
      case DataSource.forbidden:
        return Failure(
          statusCode: ResponseCode.forbidden,
          message: ResponseMessage.forbidden,
        );
      case DataSource.unauthorized:
        return Failure(
          statusCode: ResponseCode.unauthorized,
          message: ResponseMessage.unauthorized,
        );
      case DataSource.notFound:
        return Failure(
          statusCode: ResponseCode.notFound,
          message: ResponseMessage.notFound,
        );
      case DataSource.internalServerError:
        return Failure(
          statusCode: ResponseCode.internalServerError,
          message: ResponseMessage.internalServerError,
        );
      case DataSource.connectTimeout:
        return Failure(
          statusCode: ResponseCode.connectTimeout,
          message: ResponseMessage.connectTimeout,
        );
      case DataSource.cancel:
        return Failure(
          statusCode: ResponseCode.cancel,
          message: ResponseMessage.cancel,
        );
      case DataSource.receiveTimeout:
        return Failure(
          statusCode: ResponseCode.receiveTimeout,
          message: ResponseMessage.receiveTimeout,
        );
      case DataSource.sendTimeout:
        return Failure(
          statusCode: ResponseCode.sendTimeout,
          message: ResponseMessage.sendTimeout,
        );
      case DataSource.cacheError:
        return Failure(
          statusCode: ResponseCode.cacheError,
          message: ResponseMessage.cacheError,
        );
      case DataSource.noInternetConnection:
        return Failure(
          statusCode: ResponseCode.noInternetConnection,
          message: ResponseMessage.noInternetConnection,
        );
      case DataSource.badCertificate:
        return Failure(
          statusCode: ResponseCode.badCertificate,
          message: ResponseMessage.badCertificate,
        );
      case DataSource.defaultError:
        return Failure(
          statusCode: ResponseCode.defaultError,
          message: ResponseMessage.defaultError,
        );
    }
  }
}
