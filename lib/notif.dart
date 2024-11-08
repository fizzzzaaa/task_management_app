import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Android-specific initialization
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  // Initialization settings for the plugin
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Initialize the plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'System Notification Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotificationExample(),
    );
  }
}

// Function to show task notification in the system notification bar
Future<void> showTaskNotification(String message) async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'task_channel_id', // Unique ID for channel
    'Task Notifications', // Channel name for user
    channelDescription: 'This channel is for task notifications', // Channel description for user
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0, // ID for the notification
    'Task Notification', // Title of the notification
    message, // Body of the notification
    notificationDetails,
  );
}

class NotificationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('System Notification Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showTaskNotification("This is your task notification!"); // Trigger notification
          },
          child: Text("Show Notification"),
        ),
      ),
    );
  }
}
