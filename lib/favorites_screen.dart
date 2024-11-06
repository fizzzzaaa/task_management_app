import 'package:flutter/material.dart';
import 'database.dart'; // Import your SQLite database helper
import 'task_model.dart'; // Import your Task model
import 'todaytask.dart';
import 'completed_screen.dart';
import 'calendar_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Task> favoriteTasks = []; // List to hold favorite tasks
  String? taskDate; // To hold the selected date
  String? taskTime; // To hold the selected time
  int _selectedIndex = 1; // Set default index to 1 to highlight Favorites tab

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
                  labelText: taskDate == null ? 'Select Date' : taskDate,
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      taskDate = '${pickedDate.toLocal()}'.split(' ')[0];
                    });
                  }
                },
              ),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: taskTime == null ? 'Select Time' : taskTime,
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      taskTime = pickedTime.format(context);
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
      date: date,
      time: time,
      isFavorite: true,
    );
    final dbHelper = DatabaseHelper();
    await dbHelper.insertTask(newTask);
    _loadFavoriteTasks(); // Reload favorite tasks after addition
  }

  Future<void> _deleteTask(int id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteTask(id);
    _loadFavoriteTasks();
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
            _deleteTask(task.id!);
            break;
        }
      }
    });
  }

  // Function to handle bottom navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TodayTaskPage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FavoritesScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompletedScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CalendarScreen()));
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
      body: favoriteTasks.isEmpty
          ? Center(child: Text('No favorite tasks available.'))
          : ListView.builder(
        itemCount: favoriteTasks.length,
        itemBuilder: (context, index) {
          final task = favoriteTasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('${task.date} at ${task.time}'),
            trailing: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => _showTaskOptionsMenu(task),
            ),
          );
        },
      ),
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
