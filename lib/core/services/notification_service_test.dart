/// TODO NOTIFICATION

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   NotificationService() {
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//       iOS: IOSInitializationSettings(),
//     );
//     _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime) async {
//     final androidDetails = AndroidNotificationDetails(
//       'task_reminder_channel',
//       'Task Reminders',
//       'Channel for task reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     final iOSDetails = IOSNotificationDetails();
//     final notificationDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);
//
//     await _flutterLocalNotificationsPlugin.schedule(
//       id,
//       title,
//       body,
//       scheduledTime,
//       notificationDetails,
//     );
//   }
// }

/// TODO REMINDER CONTROLLER

// import 'package:miutem/core/models/Task/models/task_model.dart';
// import 'package:miutem/screens/tasklist/db_helper/db_task.dart';
// import 'notification_service.dart';
//
// class ReminderController {
//   final NotificationService _notificationService = NotificationService();
//
//   Future<void> checkAndScheduleReminders() async {
//     final tasks = await DatabaseHelper().getTasks();
//     final now = DateTime.now();
//
//     for (final task in tasks) {
//       if (task.reminder != null && task.reminder!.isAfter(now)) {
//         await _notificationService.scheduleNotification(
//           task.id!,
//           'Task Reminder',
//           'Reminder for task: ${task.title}',
//           task.reminder!,
//         );
//       }
//     }
//   }
// }

/// TODO USAGE

// void main() {
//   final reminderController = ReminderController();
//   reminderController.checkAndScheduleReminders();
//   runApp(MyApp());
// }