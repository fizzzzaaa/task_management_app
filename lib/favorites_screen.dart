import 'package:flutter/material.dart';
import 'database.dart'; // Import your DatabaseHelper
import 'task_model.dart'; // Import your Task model
import 'todaytask.dart' as todaytask; // Use alias for todaytask.dart
import 'package:task_management_app/favorites_screen.dart' as favorites;
import 'package:task_management_app/completed_screen.dart' as completed;
import 'package:task_management_app/calendar_screen.dart';
import 'menu.dart'; // If required, keep this import, but do not import TodayTaskPage from here

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Task> favoriteTasks = []; // List to hold favorite tasks
  bool isLoading = true; // Loading state for fetching tasks
  int _selectedIndex = 1; // Set default index to 1 to highlight Favorites tab

  @override
  void initState() {
    super.initState();
    _loadFavoriteTasks(); // Load favorite tasks on initialization
  }

  Future<void> _loadFavoriteTasks() async {
    try {
      final dbHelper = DatabaseHelper(); // Create an instance of DatabaseHelper
      final tasks = await dbHelper.fetchTasks(); // Fetch all tasks from the database
      setState(() {
        favoriteTasks = tasks.where((task) => task.isFavorite).toList(); // Filter for favorite tasks
        isLoading = false; // Set loading state to false after tasks are fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading state to false if there is an error
      });
      // Optionally, show a message if fetching tasks fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load favorite tasks.')),
      );
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
          MaterialPageRoute(builder: (context) => todaytask.TodayTaskPage()), // Corrected to use alias
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

  Future<void> _deleteTask(int id) async {
    final dbHelper = DatabaseHelper(); // Create an instance of DatabaseHelper
    await dbHelper.deleteTask(id); // Delete the task by ID
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
            _deleteTask(task.id!);
            break;
        }
      }
    });
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
        backgroundColor: Colors.purple[800], // Purple AppBar background
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : favoriteTasks.isEmpty
          ? Center(child: Text('No favorite tasks available.')) // No favorite tasks
          : ListView.builder(
        itemCount: favoriteTasks.length,
        itemBuilder: (context, index) {
          final task = favoriteTasks[index];
          return ListTile(
            title: Text(task.title, style: TextStyle(color: Colors.purple[800])), // Purple text for tasks
            subtitle: Text('${task.date} at ${task.time}', style: TextStyle(color: Colors.purple[600])), // Purple subtitle
            trailing: IconButton(
              icon: Icon(Icons.more_vert, color: Colors.purple[800]), // Purple icon
              onPressed: () => _showTaskOptionsMenu(task), // Show task options menu
            ),
          );
        },
      ),
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
            color: _selectedIndex == index ? Colors.white : Colors.purple[200],
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Colors.white : Colors.purple[200],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
