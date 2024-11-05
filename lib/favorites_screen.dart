import 'package:flutter/material.dart';
import 'database.dart'; // Import your SQLite database helper
import 'task_model.dart'; // Import your Task model

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Task> favoriteTasks = []; // List to hold favorite tasks
  String? taskDate; // To hold the selected date
  String? taskTime; // To hold the selected time

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
    String taskName = ''; // Variable to hold the task name

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Task Name'),
                onChanged: (value) {
                  taskName = value; // Save task name input
                },
              ),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: taskDate ?? 'Select Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  // Show date picker when the TextField is tapped
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      taskDate = '${pickedDate.toLocal()}'.split(' ')[0]; // Format date as 'YYYY-MM-DD'
                    });
                  }
                },
              ),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: taskTime ?? 'Select Time',
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: () async {
                  // Show time picker when the TextField is tapped
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      taskTime = pickedTime.format(context); // Format time as 'HH:MM AM/PM'
                    });
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (taskName.isNotEmpty && taskDate != null && taskTime != null) {
                    _saveTask(taskName, taskDate!, taskTime!);
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
      date: date,  // Include date
      time: time,  // Include time
      isFavorite: true, // Set isFavorite to true for favorite tasks
    );
    final dbHelper = DatabaseHelper();
    await dbHelper.insertTask(newTask); // Insert the task into the SQLite database
    _loadFavoriteTasks(); // Reload favorite tasks after addition
  }

  Future<void> _deleteTask(int id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteTask(id); // Delete the task from the SQLite database
    _loadFavoriteTasks(); // Reload tasks after deletion
  }

  void _showTaskOptionsMenu(Task task) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100.0, 100.0, 0.0, 0.0),
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Text('Edit Task'),
        ),
        PopupMenuItem(
          value: 'complete',
          child: Text('Mark as Completed'),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text('Delete Task'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 'edit':
          // Implement edit task functionality here
            break;
          case 'complete':
          // Implement mark as completed functionality here
            break;
          case 'delete':
            _deleteTask(task.id); // Assuming `task.id` is available
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Tasks'),
        backgroundColor: Colors.brown[800],
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality if needed
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter functionality if needed
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: favoriteTasks.length,
        itemBuilder: (context, index) {
          final task = favoriteTasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('${task.date} at ${task.time}'), // Display date and time
            trailing: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => _showTaskOptionsMenu(task), // Show options menu on button press
            ),
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
