import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// INITTALIZE
  Future<void> initNotification() async {
    if (_isInitialized) return;

    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );

    await notificationsPlugin.initialize(initSettings);
  }

  // Notification Details
  NotificationDetails notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'daily_channel_id',
          'Daily Notifications',
          channelDescription: 'Daily Notification Channel',
          importance: Importance.max,
          priority: Priority.high,
      ));
  }

  ///Show Notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
}) async {
    return notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails());
  }
}