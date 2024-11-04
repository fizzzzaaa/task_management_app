import 'package:flutter/material.dart';
import 'package:task_management_app/favorites_screen.dart';
import 'package:task_management_app/completed_screen.dart';
import 'package:task_management_app/calendar_screen.dart';
import 'package:task_management_app/database.dart'; // Import DatabaseHelper
import 'package:intl/intl.dart';


class TodayTaskPage extends StatefulWidget {
  @override
  _TodayTaskPageState createState() => _TodayTaskPageState();
}

class _TodayTaskPageState extends State<TodayTaskPage> {
  List<Map<String, dynamic>> tasks = []; // To hold the list of tasks from SQLite
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Database instance
  int _selectedIndex = 0; // Default to Today Tasks tab

  @override
  void initState() {
    super.initState();
    _loadTasksFromDatabase(); // Load tasks on initialization
  }

  // Function to load tasks from the SQLite database
  Future<void> _loadTasksFromDatabase() async {
    final data = await _dbHelper.getTasks();
    setState(() {
      tasks = data;
    });
  }

  // Function to add a new task to the database and refresh the task list
  void _addTask(String taskName, String date, String time) async {
    await _dbHelper.insertTask({
      'title': taskName,
      'date': date,
      'time': time,
      'isFavorite': 0,
      'isCompleted': 0,
    });
    _loadTasksFromDatabase();
  }

  // Function to delete a task from the database and refresh the task list
  void _deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    _loadTasksFromDatabase();
  }

  // Function to show the input modal for adding a new task
  void _showTaskInputModal() {
    String taskName = '';
    String? date;
    String? time;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Task Name'),
                  onChanged: (value) {
                    taskName = value;
                  },
                ),
                ListTile(
                  title: Text(date ?? 'Select Date', style: TextStyle(fontSize: 16)),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        date = DateFormat.yMMMMd().format(pickedDate);
                      });
                    }
                  },
                ),
                ListTile(
                  title: Text(time ?? 'Select Time', style: TextStyle(fontSize: 16)),
                  trailing: Icon(Icons.access_time),
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        time = pickedTime.format(context);
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (taskName.isNotEmpty && date != null && time != null) {
                      _addTask(taskName, date!, time!);
                      Navigator.pop(context);
                    } else {
                      // Show an error message if fields are empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all fields.')),
                      );
                    }
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to show the edit modal for updating a task
  void _showEditTaskModal(int index) {
    String taskName = tasks[index]['title'];
    String? date = tasks[index]['date'];
    String? time = tasks[index]['time'];

    TextEditingController taskNameController = TextEditingController(text: taskName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: taskNameController,
                  decoration: InputDecoration(labelText: 'Task Name'),
                  onChanged: (value) {
                    taskName = value;
                  },
                ),
                ListTile(
                  title: Text(date ?? 'Select Date', style: TextStyle(fontSize: 16)),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        date = DateFormat.yMMMMd().format(pickedDate);
                      });
                    }
                  },
                ),
                ListTile(
                  title: Text(time ?? 'Select Time', style: TextStyle(fontSize: 16)),
                  trailing: Icon(Icons.access_time),
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        time = pickedTime.format(context);
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (taskNameController.text.isNotEmpty && date != null && time != null) {
                      _dbHelper.updateTask({
                        'id': tasks[index]['id'],
                        'title': taskNameController.text,
                        'date': date,
                        'time': time,
                        'isFavorite': tasks[index]['isFavorite'],
                        'isCompleted': tasks[index]['isCompleted'],
                      });
                      _loadTasksFromDatabase();
                      Navigator.pop(context);
                    } else {
                      // Show an error message if fields are empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all fields.')),
                      );
                    }
                  },
                  child: Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Dropdown menu for each task with options
  Widget _buildTaskMenu(int index) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'Edit') {
          _showEditTaskModal(index);
        } else if (value == 'Delete') {
          _deleteTask(tasks[index]['id']); // Pass the task ID instead of index
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'Edit',
            child: Text('Edit'),
          ),
          PopupMenuItem(
            value: 'Delete',
            child: Text('Delete'),
          ),
        ];
      },
    );
  }

  // Build method for rendering UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Tasks'),
        backgroundColor: Colors.brown[800],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(tasks[index]['title']),
              subtitle: Text('${tasks[index]['date']} at ${tasks[index]['time']}'),
              trailing: _buildTaskMenu(index),
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
