import 'package:flutter/material.dart';
import 'package:coach_app/core/di/dependency_injection.dart';
import 'package:coach_app/core/helper/local_storage.dart';
import 'package:coach_app/core/helper/notification_helper.dart';
import 'package:coach_app/core/networking/dio_factory.dart';

class AppSessionManager {
  AppSessionManager._();

  /// Resets all user-specific data from storage and networking
  static Future<void> resetAllUserSessionData(BuildContext? context) async {
    // Preserve saved username and preferences
    final savedUsername =
        await LocalStorage.getData('saved_username') ??
        await LocalStorage.getData('Saved_username');
    final rememberMe = await LocalStorage.getBool('remember_me');

    // 1. Destroy FCM token and cancel all active notifications
    try {
      await NotificationHelper.deleteFcmToken();
    } catch (e) {
      debugPrint('NotificationHelper delete token error: $e');
    }

    // 2. Clear local storage and tokens
    await LocalStorage.clearAll();
    DioFactory.clearTokenFromHeader();

    // 3. Restore preserved preferences
    if (savedUsername != null && savedUsername.isNotEmpty) {
      await LocalStorage.setData('saved_username', savedUsername);
    }
    if (rememberMe != null) {
      await LocalStorage.setData('remember_me', rememberMe);
    }
  }

  /// Global reset method for non-UI triggers (e.g. 401 interceptor)
  static Future<void> resetFromGlobalContext() async {
    final context = getIt<GlobalKey<NavigatorState>>().currentContext;
    await resetAllUserSessionData(context);
  }
}
