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

  // Function to handle bottom navigation
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TodayTaskPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FavoritesScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CompletedScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CalendarScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        title: Text('Today\'s Tasks'),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? Center(
        child: Text('No tasks added yet!', style: TextStyle(fontSize: 20)),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(tasks[index]['title']),
              subtitle: Text('Due: ${tasks[index]['date']} at ${tasks[index]['time']}'),
              trailing: _buildTaskMenu(index), // Popup menu for options
              onTap: () {
                // Show the edit task modal on tapping the list item
                _showEditTaskModal(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskInputModal, // Show modal for adding new task
        backgroundColor: Colors.brown[800],
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Today\'s Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
