import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database.dart'; // Import the database helper
import 'task_model.dart'; // Import the Task model
import 'favorites_screen.dart';
import 'completed_screen.dart';
import 'calendar_screen.dart';
import 'menu.dart';

class TodayTaskPage extends StatefulWidget {
  @override
  _TodayTaskPageState createState() => _TodayTaskPageState();
}

class _TodayTaskPageState extends State<TodayTaskPage> {
  List<Task> tasks = []; // List to hold tasks retrieved from the database
  int _selectedIndex = 0; // Track the selected index for the bottom navigation bar

  @override
  void initState() {
    super.initState();
    _loadTasksFromDatabase(); // Load tasks on initialization
  }

  Future<void> _loadTasksFromDatabase() async {
    final dbHelper = DatabaseHelper(); // Create an instance of DatabaseHelper
    final allTasks = await dbHelper.fetchTasks(); // Get all tasks from the database
    setState(() {
      tasks = allTasks; // Update the tasks list with the fetched tasks
    });
  }

  void _addTask(String taskName, String date, String time, String repeat) async {
    final newTask = Task(
      title: taskName,
      date: date,
      time: time,
      repeat: repeat,
    );
    final dbHelper = DatabaseHelper(); // Create an instance of DatabaseHelper
    await dbHelper.insertTask(newTask); // Insert the task into the database
    _loadTasksFromDatabase(); // Refresh the tasks list after adding a new task
  }

  void _deleteTask(int id) async {
    final dbHelper = DatabaseHelper(); // Create an instance of DatabaseHelper
    await dbHelper.deleteTask(id); // Delete the task from the database
    _loadTasksFromDatabase(); // Refresh the task list after deletion
  }

  // Toggle completion status by creating a new Task instance with updated isCompleted status
  void _toggleTaskCompletion(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      date: task.date,
      time: task.time,
      isFavorite: task.isFavorite,
      isCompleted: !task.isCompleted,
      repeat: task.repeat,
    );
    final dbHelper = DatabaseHelper(); // Create an instance of DatabaseHelper
    await dbHelper.updateTask(updatedTask); // Update the task in the database
    _loadTasksFromDatabase(); // Refresh the tasks list
  }

  // Toggle favorite status by creating a new Task instance with updated isFavorite status
  void _toggleTaskFavorite(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      date: task.date,
      time: task.time,
      isFavorite: !task.isFavorite,
      isCompleted: task.isCompleted,
      repeat: task.repeat,
    );
    final dbHelper = DatabaseHelper(); // Create an instance of DatabaseHelper
    await dbHelper.updateTask(updatedTask); // Update the task in the database
    _loadTasksFromDatabase(); // Refresh the tasks list
  }

  void _showTaskInputModal() {
    String taskName = '';
    String? date;
    String? time;
    String repeat = 'Never'; // Default repeat option

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
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Repeat'),
                  value: repeat,
                  items: <String>['Never', 'Daily', 'Weekly', 'Monthly']
                      .map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      repeat = newValue!; // Update the repeat option
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (taskName.isNotEmpty && date != null && time != null) {
                      _addTask(taskName, date!, time!, repeat);
                      Navigator.pop(context); // Close the modal after saving
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

  // Adjust the navigation when bottom navigation item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });

    // Navigation logic for the bottom navigation buttons
    switch (index) {
      case 0:
        break; // No action needed because this page is the default
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(Icons.check_circle, 'Today\'s Tasks', 0),
            _buildNavButton(Icons.favorite, 'Favorites', 1),
            _buildNavButton(Icons.check_circle, 'Completed', 2),
            _buildNavButton(Icons.calendar_today, 'Calendar', 3),
          ],
        ),
        backgroundColor: Colors.brown[800],
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(tasks[index].title),
              subtitle: Text('${tasks[index].date} at ${tasks[index].time}\nRepeats: ${tasks[index].repeat}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      tasks[index].isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: tasks[index].isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      _toggleTaskFavorite(tasks[index]);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      tasks[index].isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: tasks[index].isCompleted ? Colors.green : Colors.grey,
                    ),
                    onPressed: () {
                      _toggleTaskCompletion(tasks[index]);
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Delete') {
                        _deleteTask(tasks[index].id!); // Delete task by ID
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(value: 'Delete', child: Text('Delete')),
                      ];
                    },
                  ),
                ],
              ),
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

  // Build navigation buttons for each section
  Widget _buildNavButton(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        _onItemTapped(index);
      },
      child: Column(
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Colors.white : Colors.brown[200],
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Colors.white : Colors.brown[200],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
