import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Define the Task model directly in this file
class TaskModel {
  final String title;
  final String date;
  final String time;
  final bool isFavorite;

  TaskModel({
    required this.title,
    required this.date,
    required this.time,
    this.isFavorite = false,
  });

  // Method to convert TaskModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'time': time,
      'isFavorite': isFavorite,
    };
  }

  // Method to create TaskModel from a Map
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      title: map['title'],
      date: map['date'],
      time: map['time'],
      isFavorite: map['isFavorite'] ?? false,
    );
  }
}

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Box<Map<String, dynamic>> taskBox; // Declare taskBox

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<Map<String, dynamic>>('tasks'); // Initialize taskBox in initState
  }

  void _showTaskInputModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        String taskName = '';
        String taskDate = '';
        String taskTime = '';

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Task Name'),
                onChanged: (value) {
                  taskName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Date'),
                onChanged: (value) {
                  taskDate = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Time'),
                onChanged: (value) {
                  taskTime = value;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (taskName.isNotEmpty && taskDate.isNotEmpty && taskTime.isNotEmpty) {
                    _saveTask(taskName, taskDate, taskTime);
                    Navigator.pop(context); // Close the modal
                  }
                },
                child: Text('Save Task'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveTask(String name, String date, String time) {
    final newTask = TaskModel(title: name, date: date, time: time, isFavorite: true);
    taskBox.add(newTask.toMap()); // Add the new task to the Hive box
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Tasks'),
        backgroundColor: Colors.brown[800],
        automaticallyImplyLeading: false,
      ),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box<Map<String, dynamic>> tasks, _) {
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final taskData = tasks.getAt(index);
              final task = TaskModel.fromMap(taskData!); // Convert Map to TaskModel
              return ListTile(
                title: Text(task.title),
                subtitle: Text('${task.date} at ${task.time}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskInputModal,
        child: Icon(Icons.add),
        backgroundColor: Colors.brown[800],
      ),
    );
  }
}
