import 'package:flutter/material.dart';
import 'package:task_management_app/favorites_screen.dart';
import 'package:task_management_app/completed_screen.dart';
import 'package:task_management_app/todaytask.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _selectedIndex = 3; // Calendar tab is selected by default

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CalendarScreen()),
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
      // Already in CalendarScreen, do nothing
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
            _buildNavButton(Icons.list, 'All Tasks', 0),
            _buildNavButton(Icons.favorite, 'Favorites', 1),
            _buildNavButton(Icons.check_circle, 'Completed', 2),
            _buildNavButton(Icons.calendar_today, 'Calendar', 3),
          ],
        ),
        automaticallyImplyLeading: false, // Removes back button
      ),
      body: Center(
        child: Text(
          'Calendar Screen Content Here',
          style: TextStyle(fontSize: 20),
        ),
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
