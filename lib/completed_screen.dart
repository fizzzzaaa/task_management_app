import 'package:flutter/material.dart';
import 'database.dart'; // Import the database helper
import 'task_model.dart'; // Import the Task model
import 'todaytask.dart' as todaytask;
import 'favorites_screen.dart';
import 'calendar_screen.dart';
import 'menu.dart';

class CompletedScreen extends StatefulWidget {
  final Function toggleTheme;

  CompletedScreen({required this.toggleTheme});

  @override
  _CompletedScreenState createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  List<Task> completedTasks = []; // List to hold completed tasks
  int _selectedIndex = 2; // Set default index to 2 to highlight Completed tab
  bool isLoading = true; // Loading state for fetching tasks

  @override
  void initState() {
    super.initState();
    _loadCompletedTasks(); // Load completed tasks on initialization
  }

  // Function to load completed tasks
  Future<void> _loadCompletedTasks() async {
    final dbHelper = DatabaseHelper(); // Get the instance of DatabaseHelper
    try {
      final tasks = await dbHelper.fetchTasks(); // Fetch all tasks from the database
      setState(() {
        completedTasks = tasks.where((task) => task.isCompleted).toList(); // Filter completed tasks
        isLoading = false; // Set loading state to false after tasks are fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading state to false in case of error
      });
    }
  }

  // Function to delete a task
  Future<void> _deleteTask(int taskId) async {
    final dbHelper = DatabaseHelper(); // Get the instance of DatabaseHelper
    try {
      await dbHelper.deleteTask(taskId); // Delete task by its ID
      setState(() {
        completedTasks.removeWhere((task) => task.id == taskId); // Remove task from list
      });
    } catch (e) {
      // Optionally handle the error if needed
    }
  }

  // Function to handle bottom navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  todaytask.TodayTaskPage(toggleTheme: widget.toggleTheme)),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FavoritesScreen(toggleTheme: widget.toggleTheme)),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CompletedScreen(toggleTheme: widget.toggleTheme)),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CalendarScreen(toggleTheme: widget.toggleTheme)),
        );
        break;
    }
  }

  // Function to show task details in a dialog
  void _showTaskDetailsDialog(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(task.title),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Date: ${task.date}'),
              Text('Time: ${task.time}'),

              // Add any other fields you want to display
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(Icons.check_circle, 'Tasks', 0),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : completedTasks.isEmpty
          ? Center(child: Text('No completed tasks available.'))
          : ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          if (task.id != null) { // Check if task has a non-null id
            return ListTile(
              title: Text(task.title),
              subtitle: Text('${task.date} at ${task.time}'),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.purple),
                onPressed: () {
                  _deleteTask(task.id!); // Delete task by its ID
                },
              ),
              onTap: () {
                // Show task details in a dialog when the task is tapped
                _showTaskDetailsDialog(task);
              },
            );
          } else {
            // Handle the case where id is null (if necessary)
            return ListTile(
              title: Text(task.title),
              subtitle: Text('No valid ID'),
            );
          }
        },
      ),
      drawer: MenuDrawer(toggleTheme: widget.toggleTheme),
    );
  }

  // Custom widget to create navigation buttons
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
