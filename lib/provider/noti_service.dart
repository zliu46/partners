import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class NotiService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const AndroidInitializationSettings androidInitSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
    );

    await notificationsPlugin.initialize(initSettings);

    // Request permission for notifications
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    _isInitialized = true;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'task_reminder_channel',
        'Task Reminders',
        channelDescription: 'Reminders for upcoming tasks',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  /// Show a notification immediately**
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  /// Schedule a notification
  Future<void>scheduleTaskNotification ({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,

  }) async {
     final now = tz.TZDateTime.now(tz.local);

     var scheduledDate = tz.TZDateTime(
       tz.local,
       now.year,
       now.month,
       now.day,
       hour,
       minute,
     );

     await notificationsPlugin.zonedSchedule(
         id,
         title,
         body,
         scheduledDate,
         notificationDetails(),

         uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
         androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle
     );
     print("Current Timezone: ${tz.local}");
     print("Task Notification scheduled for $scheduledDate!");
  }
}


