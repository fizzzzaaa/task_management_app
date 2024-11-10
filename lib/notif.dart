import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart'; // Importing intl for date formatting (optional if you need it)

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Android-specific initialization
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@drawable/app_icon'); // Correct icon

  // Initialization settings for the plugin
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Initialize the plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create notification channel (required for Android 8.0 and above)
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'task_channel_id', // Channel ID
    'Task Notifications', // Channel Name
    description: 'This channel is for task notifications', // Channel description
    importance: Importance.max, // Max priority
    playSound: true,
  );

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder Notification Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotificationExample(),
    );
  }
}

// Function to show a scheduled task reminder notification
Future<void> showTaskReminderNotification(DateTime reminderTime, String message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'task_channel_id', // Channel ID
    'Task Notifications', // Channel name visible to the user
    channelDescription: 'This channel is for task notifications', // Channel description
    importance: Importance.max, // High priority
    priority: Priority.high,
    playSound: true,
    icon: '@drawable/app_icon', // Ensure this icon exists in your 'drawable' folder
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
  );

  // Schedule notification using the 'schedule' method
 // await flutterLocalNotificationsPlugin.schedule(
   // 0, // Notification ID
    //'Task Reminder', // Notification Title
   // message, // Body of the notification
//    reminderTime, // Use the reminderTime directly (local time)
  //  notificationDetails,
    //androidAllowWhileIdle: true, // Allow the notification to show even when the app is in the background
  //);
}

class NotificationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder Notification Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Set a reminder time 5 seconds from now (modify as needed)
            final reminderTime = DateTime.now().add(Duration(seconds: 5));
            showTaskReminderNotification(reminderTime, "This is your task reminder!"); // Trigger notification
          },
          child: Text("Schedule Reminder"),
        ),
      ),
    );
  }
}
