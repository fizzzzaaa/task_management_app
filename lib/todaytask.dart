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
      'isFavorite': false,
      'isCompleted': false,
    });
    _loadTasksFromDatabase();
  }

  // Function to delete a task from the database and refresh the task list
  void _deleteTask(int index) async {
    await _dbHelper.deleteTask(tasks[index]['id']);
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
                  title: Text(date ?? 'Date', style: TextStyle(fontSize: 16)),
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
                  title: Text(time ?? 'Time', style: TextStyle(fontSize: 16)),
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
                  title: Text(date ?? 'Date', style: TextStyle(fontSize: 16)),
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
                  title: Text(time ?? 'Time', style: TextStyle(fontSize: 16)),
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
      icon: Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) {
        if (value == 'Favorite') {
          setState(() {
            tasks[index]['isFavorite'] = !(tasks[index]['isFavorite'] ?? false);
          });
        } else if (value == 'Edit') {
          _showEditTaskModal(index);
        } else if (value == 'Delete') {
          _deleteTask(index);
        } else if (value == 'Complete') {
          setState(() {
            tasks[index]['isCompleted'] = true;
          });
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: 'Favorite',
            child: ListTile(
              leading: Icon(Icons.favorite, color: Colors.red),
              title: Text('Favorite'),
            ),
          ),
          PopupMenuItem(
            value: 'Edit',
            child: ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Edit'),
            ),
          ),
          PopupMenuItem(
            value: 'Delete',
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete'),
            ),
          ),
          PopupMenuItem(
            value: 'Complete',
            child: ListTile(
              leading: Icon(Icons.check, color: Colors.green),
              title: Text('Complete'),
            ),
          ),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavButton(context, Icons.list, 'All Tasks', AllTasksScreen()),
            _buildNavButton(context, Icons.favorite, 'Favorites', FavoritesScreen()),
            _buildNavButton(context, Icons.check_circle, 'Completed', CompletedScreen()),
            _buildNavButton(context, Icons.calendar_today, 'Calendar', CalendarScreen()),
          ],
        ),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? Center(
          child: Text('No tasks added yet!', style: TextStyle(fontSize: 20)))
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.brown[400],
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                tasks[index]['title'] ?? '',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Scheduled: ${tasks[index]['date']}\nTime: ${tasks[index]['time']}',
                style: TextStyle(color: Colors.white),
              ),
              trailing: _buildTaskMenu(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskInputModal,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.brown[800],
      ),
    );
  }

  // Helper method to build nav buttons
  IconButton _buildNavButton(BuildContext context, IconData icon, String label, Widget screen) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      color: Colors.white,
    );
  }
}
