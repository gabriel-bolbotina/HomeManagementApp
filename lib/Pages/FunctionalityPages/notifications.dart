import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  late final InitializationSettings initializationSettings;// Replace 'app_icon' with your actual app icon's name.

  Notifications() {
    tz.initializeTimeZones();
    var androidSettings = AndroidInitializationSettings('app_icon');
    initializationSettings = InitializationSettings(
        android: androidSettings,
    );
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);
  }

 void selectNotification(NotificationResponse? payload) {
    // Handle notification tap
  }

  void scheduleNotification(TimeOfDay time) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'reminder_channel_id', 'Reminder',
      channelDescription: 'Channel for reminder notification',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Reminder',
        'Don\'t forget to check your commonly forgotten items!',
        _nextInstanceOfTime(time),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day + 1,
          time.hour, time.minute);
    }
    return scheduledDate;
  }
}
