import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService._internal() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> init() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showWaterGoalNotification(int current, int goal) async {
    String notificationBody;

    if (current >= goal) {
      notificationBody =
          "🎉 Congratulations! You've reached your water goal of $goal ml.";
    } else {
      final remaining = goal - current;
      notificationBody =
          "💧 Keep going! Only $remaining ml left to reach your goal.";
    }

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'water_goal_channel',
      'Water Goal Notifications',
      channelDescription: 'Notifications about water intake goals',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Water Intake Reminder',
      notificationBody,
      platformChannelSpecifics,
    );
  }
}
