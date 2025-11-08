// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// class NotificationService {
//   // Singleton
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();
//
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   Future<void> init() async {
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const settings = InitializationSettings(android: android);
//     await _notificationsPlugin.initialize(settings);
//   }
//
//   Future<void> showNow(String title, String body) async {
//     const android = AndroidNotificationDetails(
//       'task_channel',
//       'TaskMate Notifications',
//       channelDescription: 'Notifications for task due dates',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//
//     await _notificationsPlugin.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       title,
//       body,
//       const NotificationDetails(android: android),
//     );
//   }
//
//   Future<void> scheduleNotification(String title, String body, DateTime scheduleTime) async {
//     final tzTime = tz.TZDateTime.from(scheduleTime, tz.local);
//
//     const android = AndroidNotificationDetails(
//       'task_channel',
//       'TaskMate Notifications',
//       channelDescription: 'Notifications for task due dates',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//
//     await _notificationsPlugin.zonedSchedule(
//       tzTime.millisecondsSinceEpoch ~/ 1000,
//       title,
//       body,
//       tzTime,
//       const NotificationDetails(android: android),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.dateAndTime,
//       androidAllowWhileIdle: true,
//     );
//   }
// }
