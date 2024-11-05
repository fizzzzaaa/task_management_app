import 'package:flutter/material.dart';
import 'database.dart'; // Import the database helper
import 'task_model.dart'; // Import the Task model

class CompletedScreen extends StatefulWidget {
  @override
  _CompletedScreenState createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  List<Task> completedTasks = []; // List to hold completed tasks

  @override
  void initState() {
    super.initState();
    _loadCompletedTasks(); // Load completed tasks on initialization
  }

  Future<void> _loadCompletedTasks() async {
    final dbHelper = DatabaseHelper(); // Get the instance of DatabaseHelper
    final tasks = await dbHelper.getAllTasks(); // Fetch all tasks from the database
    setState(() {
      // Assuming you have a way to check if a task is completed
      completedTasks = tasks.where((task) => task.isCompleted).toList(); // Filter completed tasks
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
        backgroundColor: Colors.brown[800],
      ),
      body: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(completedTasks[index].title),
            subtitle: Text('${completedTasks[index].date} at ${completedTasks[index].time}'),
          );
        },
      ),
    );
  }
}
