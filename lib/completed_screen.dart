import 'package:flutter/material.dart';
import 'database.dart'; // Import the database helper
import 'task_model.dart'; // Import the Task model
import 'todaytask.dart' as todaytask;
import 'favorites_screen.dart';
import 'calendar_screen.dart';
import 'menu.dart';

class CompletedScreen extends StatefulWidget {
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
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load completed tasks.')),
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
          MaterialPageRoute(builder: (context) => todaytask.TodayTaskPage()),
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
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner while data is being fetched
          : completedTasks.isEmpty
          ? Center(child: Text('No completed tasks available.'))
          : ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(completedTasks[index].title),
            subtitle: Text('${completedTasks[index].date} at ${completedTasks[index].time}'),
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
