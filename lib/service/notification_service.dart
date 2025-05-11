import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await _setupFlutterNotifications();
    await _firebaseBackgroundHandlerSetup();

    // Ask permission
    NotificationSettings settings = await _messaging.requestPermission();
    print('🔒 Permission granted: ${settings.authorizationStatus}');

    // Token
    String? token = await _messaging.getToken();
    print("✅ FCM Token: $token");

    // Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📲 Foreground message received: ${message.notification?.title}");
      _showNotification(
        message.notification?.title ?? '',
        message.notification?.body ?? '',
      );
    });

    // When app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🟢 Notification clicked: ${message.data}");
    });
  }

  static Future<void> _firebaseBackgroundHandlerSetup() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _setupFlutterNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  static Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'General Notifications',
          importance: Importance.max,
          priority: Priority.high,
        );
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(0, title, body, details);
  }
}

// Must be top-level
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📦 Background message: ${message.messageId}");
}
