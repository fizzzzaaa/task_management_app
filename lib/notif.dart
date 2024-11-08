import 'package:flutter/material.dart';

class TaskNotification extends StatelessWidget {
  final String message; // The message to display in the notification
  final Duration duration; // Duration for how long the notification will show

  TaskNotification({
    required this.message,
    this.duration = const Duration(seconds: 2), // Default to 2 seconds
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.black, // Notification background color
      width: double.infinity, // Make it full width
      child: Row(
        children: [
          Icon(
            Icons.notification_important,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Function to show task notifications
void showTaskNotification(BuildContext context, String message, {Duration duration = const Duration(seconds: 2)}) {
  final notification = TaskNotification(message: message, duration: duration);

  // Show notification at the top of the screen
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents closing by tapping outside
    builder: (BuildContext context) {
      Future.delayed(duration, () {
        Navigator.of(context).pop(); // Close the notification after the duration
      });

      return Dialog(
        backgroundColor: Colors.transparent, // Make the background transparent
        child: notification,
      );
    },
  );
}
