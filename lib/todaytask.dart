import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database.dart';
import 'task_model.dart';
import 'favorites_screen.dart';
import 'completed_screen.dart';
import 'calendar_screen.dart';
import 'menu.dart'; // Import the menu.dart file here

class TodayTaskPage extends StatefulWidget {
  final Function toggleTheme;  // Add toggleTheme as a parameter

  TodayTaskPage({required this.toggleTheme});  // Accept toggleTheme in the constructor

  @override
  _TodayTaskPageState createState() => _TodayTaskPageState();
}

class _TodayTaskPageState extends State<TodayTaskPage> {
  List<Task> tasks = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTasksFromDatabase(); // Load tasks on initialization
  }

  Future<void> _loadTasksFromDatabase() async {
    final dbHelper = DatabaseHelper();
    final allTasks = await dbHelper.fetchTasks(); // Updated to use fetchTasks
    setState(() {
      tasks = allTasks;
    });
  }

  void _addTask(String taskName, String date, String time, String repeat) async {
    final newTask = Task(title: taskName, date: date, time: time, repeat: repeat, isFavorite: false, isCompleted: false);
    final dbHelper = DatabaseHelper();
    await dbHelper.insertTask(newTask);
    setState(() {
      tasks.add(newTask);
    });
  }

  void _deleteTask(int id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteTask(id);
    _loadTasksFromDatabase(); // Refresh task list
  }

  // Function to show the input modal for adding a new task
  void _showTaskInputModal() {
    String taskName = '';
    String? date;
    String? time;
    String repeat = 'None'; // Default repeat option

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
                ListTile(
                  title: Text("Repeat"),
                  trailing: DropdownButton<String>(
                    value: repeat,
                    items: ['None', 'Daily', 'Weekly', 'Monthly'].map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        repeat = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (taskName.isNotEmpty && date != null && time != null) {
                      _addTask(taskName, date!, time!, repeat);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[800],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to toggle favorite status
  void _toggleFavorite(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      date: task.date,
      time: task.time,
      repeat: task.repeat,
      isFavorite: !task.isFavorite,  // Toggle the favorite status
      isCompleted: task.isCompleted,
    );
    final dbHelper = DatabaseHelper();
    await dbHelper.insertTask(updatedTask); // Update task in the database
    setState(() {
      task.isFavorite = updatedTask.isFavorite;
    });
  }

  // Function to toggle completed status
  void _toggleCompleted(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      date: task.date,
      time: task.time,
      repeat: task.repeat,
      isFavorite: task.isFavorite,
      isCompleted: !task.isCompleted,  // Toggle the completed status
    );
    final dbHelper = DatabaseHelper();
    await dbHelper.insertTask(updatedTask); // Update task in the database
    setState(() {
      task.isCompleted = updatedTask.isCompleted;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TodayTaskPage(toggleTheme: widget.toggleTheme),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FavoritesScreen(toggleTheme: widget.toggleTheme),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CompletedScreen(toggleTheme: widget.toggleTheme),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CalendarScreen(toggleTheme: widget.toggleTheme),
          ),
        );
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
        backgroundColor: Colors.purple[800],
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer automatically
            },
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(tasks[index].title),
              subtitle: Text('${tasks[index].date} at ${tasks[index].time} - ${tasks[index].repeat}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      tasks[index].isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: tasks[index].isFavorite ? Colors.purple : null,
                    ),
                    onPressed: () {
                      _toggleFavorite(tasks[index]);  // Toggle favorite status
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      tasks[index].isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                      color: tasks[index].isCompleted ? Colors.purple : null,
                    ),
                    onPressed: () {
                      _toggleCompleted(tasks[index]);  // Toggle completed status
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Delete') {
                        _deleteTask(tasks[index].id!); // Use the task ID for deletion
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
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
        backgroundColor: Colors.purple[800],
      ),
      drawer: MenuDrawer(toggleTheme: widget.toggleTheme), // Pass toggleTheme to MenuDrawer
    );
  }

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
