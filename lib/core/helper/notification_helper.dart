import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coach_app/core/helper/local_storage.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'coach_channel_1',
    'Coach Notifications',
    description: 'Official Coach notifications with alert sound.',
    importance: Importance.max,
    playSound: true,
  );

  static Future<void> initialize() async {
    // 1. Initialize Local Notifications
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/launcher_icon');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          if (kDebugMode) {
            print("Notification clicked: ${details.payload}");
          }
          navigateToNotifications();
        },
      );

      // Create the notification channel on Android
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);
    } catch (e) {
      debugPrint("Local notifications initialization error: $e");
    }

    // 2. Initialize Firebase Messaging
    if (Firebase.apps.isEmpty) {
      debugPrint(
        "Firebase is not initialized. Skipping Firebase Messaging setup.",
      );
      return;
    }

    try {
      final messaging = FirebaseMessaging.instance;

      try {
        NotificationSettings settings = await messaging
            .requestPermission(
              alert: true,
              announcement: false,
              badge: true,
              carPlay: false,
              criticalAlert: false,
              provisional: false,
              sound: true,
            )
            .timeout(const Duration(seconds: 4));

        if (kDebugMode) {
          print('User granted permission: ${settings.authorizationStatus}');
        }
      } catch (e) {
        debugPrint("Error requesting notification permission: $e");
      }

      try {
        FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler,
        );
      } catch (e) {
        debugPrint("Error setting background handler: $e");
      }

      try {
        await messaging
            .setForegroundNotificationPresentationOptions(
              alert: true,
              badge: true,
              sound: true,
            )
            .timeout(const Duration(seconds: 2))
            .catchError((_) {});
      } catch (_) {}

      // Foreground message listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        if (kDebugMode) {
          print("Received a foreground message: ${message.messageId}");
        }

        final token = await LocalStorage.getData('token');
        if (token == null || token.isEmpty) {
          return;
        }

        final bool notificationsEnabled = await isNotificationsEnabled();
        if (!notificationsEnabled) {
          return;
        }

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null && !kIsWeb) {
          _localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                channelDescription: _channel.description,
                icon: '@mipmap/launcher_icon',
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            payload: jsonEncode(message.data),
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        navigateToNotifications();
      });

      FirebaseMessaging.instance
          .getInitialMessage()
          .then((message) {
            if (message != null) {
              navigateToNotifications();
            }
          })
          .catchError((e) {
            debugPrint("Error getting initial message: $e");
          });

      await subscribeToUpdateTopics();
      await getFcmToken();
    } catch (e) {
      debugPrint("Error during FirebaseMessaging initialization: $e");
    }
  }

  static void navigateToNotifications() {
    // سيتم التوجيه لشاشة الإشعارات الخاصة بالكوتش فور إنشائها
    debugPrint("Navigate to notifications view");
  }

  static const String topicAndroidUpdates = 'coach_app_updates_android';

  static Future<void> subscribeToUpdateTopics() async {
    try {
      if (!kIsWeb && Platform.isAndroid && Firebase.apps.isNotEmpty) {
        await FirebaseMessaging.instance
            .subscribeToTopic(topicAndroidUpdates)
            .timeout(
              const Duration(seconds: 4),
              onTimeout: () {
                debugPrint('FCM subscribeToTopic timed out');
              },
            );
      }
    } catch (e) {
      debugPrint('Error subscribing to FCM update topic: $e');
    }
  }

  static Future<String?> getFcmToken() async {
    try {
      if (Firebase.apps.isEmpty) return null;
      String? token = await FirebaseMessaging.instance.getToken().timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          debugPrint("FCM getToken timed out");
          return null;
        },
      );
      return token;
    } catch (e) {
      debugPrint("Error getting FCM token: $e");
      return null;
    }
  }

  static Future<void> deleteFcmToken() async {
    try {
      await _localNotifications.cancelAll();
    } catch (_) {}

    try {
      if (Firebase.apps.isEmpty) return;
      await FirebaseMessaging.instance.deleteToken().timeout(
        const Duration(seconds: 4),
        onTimeout: () {},
      );
    } catch (e) {
      debugPrint("Error deleting FCM token: $e");
    }
  }

  static const String keyNotificationsEnabled = 'push_notifications_enabled';
  static bool? _inMemoryNotificationsEnabled;

  static Future<bool> isNotificationsEnabled() async {
    if (_inMemoryNotificationsEnabled != null) {
      return _inMemoryNotificationsEnabled!;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final val = prefs.get(keyNotificationsEnabled);
      _inMemoryNotificationsEnabled = (val == null || val == true);
      return _inMemoryNotificationsEnabled!;
    } catch (_) {
      return true;
    }
  }

  static Future<void> setNotificationsEnabled(bool enabled) async {
    _inMemoryNotificationsEnabled = enabled;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyNotificationsEnabled, enabled);
      if (!enabled) {
        await _localNotifications.cancelAll();
      }
    } catch (_) {}
  }
}
