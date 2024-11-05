import 'package:flutter/material.dart';
import 'database.dart'; // Import your SQLite database helper
import 'task_model.dart'; // Import your Task model

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Task> favoriteTasks = []; // List to hold favorite tasks

  @override
  void initState() {
    super.initState();
    _loadFavoriteTasks(); // Load favorite tasks on initialization
  }

  Future<void> _loadFavoriteTasks() async {
    final dbHelper = DatabaseHelper(); // Create an instance of DatabaseHelper
    final tasks = await dbHelper.getAllTasks(); // Fetch all tasks from the database
    setState(() {
      favoriteTasks = tasks.where((task) => task.isFavorite).toList(); // Filter for favorite tasks
    });
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

  Future<void> _saveTask(String name, String date, String time) async {
    final newTask = Task(
      title: name,
      date: date,
      time: time,
      isFavorite: true, // Set isFavorite to true for favorite tasks
    );
    final dbHelper = DatabaseHelper();
    await dbHelper.insertTask(newTask); // Insert the task into the SQLite database
    _loadFavoriteTasks(); // Reload favorite tasks after addition
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Tasks'),
        backgroundColor: Colors.brown[800],
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: favoriteTasks.length,
        itemBuilder: (context, index) {
          final task = favoriteTasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('${task.date} at ${task.time}'),
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
