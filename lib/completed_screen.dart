import 'package:flutter/material.dart';
import 'package:task_management_app/favorites_screen.dart';
import 'package:task_management_app/calendar_screen.dart';
import 'package:task_management_app/todaytask.dart';
import 'database.dart'; // Import the database helper
import 'task_model.dart'; // Import TaskModel

class CompletedScreen extends StatefulWidget {
  @override
  _CompletedScreenState createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  int _selectedIndex = 2; // Completed tab is selected by default
  List<TaskModel> completedTasks = [];

  @override
  void initState() {
    super.initState();
    _loadCompletedTasks(); // Load completed tasks
  }

  Future<void> _loadCompletedTasks() async {
    final dbHelper = DatabaseHelper();
    final tasks = await dbHelper.queryAllTasks(); // Get all tasks (you may filter for completed ones)
    setState(() {
      completedTasks = tasks; // Update completed tasks
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
      // Already in CompletedScreen, do nothing
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(Icons.list, 'Today\'s Tasks', 0),
            _buildNavButton(Icons.favorite, 'Favorites', 1),
            _buildNavButton(Icons.check_circle, 'Completed', 2),
            _buildNavButton(Icons.calendar_today, 'Calendar', 3),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(completedTasks[index].title),
              subtitle: Text('${completedTasks[index].date} at ${completedTasks[index].time}'),
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
