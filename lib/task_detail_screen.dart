// task_detail_screen.dart
import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String repeatDay;

  TaskDetailScreen({
    required this.title,
    required this.date,
    required this.time,
    required this.repeatDay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        backgroundColor: Colors.brown[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: $title', style: TextStyle(fontSize: 20)),
            Text('Date: $date', style: TextStyle(fontSize: 20)),
            Text('Time: $time', style: TextStyle(fontSize: 20)),
            Text('Repeat: $repeatDay', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
