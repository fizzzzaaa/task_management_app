import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task_model.dart'; // Import the Task model

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Box<TaskModel> taskBox; // Declare taskBox

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<TaskModel>('tasks'); // Initialize taskBox in initState
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
    taskBox.add(newTask); // Add the new task to the Hive box
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
        builder: (context, Box<TaskModel> tasks, _) {
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks.getAt(index);
              return ListTile(
                title: Text(task?.title ?? 'No Title'), // Updated to handle null
                subtitle: Text('${task?.date} at ${task?.time}'),
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
