import 'package:flutter/material.dart';
import 'todaytask.dart'; // Assuming TodayTaskPage is one of the screens you navigate to
import 'completed_screen.dart'; // Example of another screen you may navigate to
import 'favorites_screen.dart'; // Example screen

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple[800], // Matching theme color
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          // Theme switcher
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Theme'),
            trailing: Switch(
              value: false, // Placeholder value for switch state
              onChanged: (value) {
                // Handle theme change (e.g., change between dark and light themes)
                // Example: Implement theme switcher using Provider or any state management
              },
            ),
          ),
          // Notifications setting
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              // Handle notifications setting (maybe open a settings screen)
              Navigator.pop(context); // Close the drawer
            },
          ),
          // Progress tracking
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Progress'),
            onTap: () {
              // Handle progress tracking
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompletedScreen()),
              ); // Navigate to progress tracking screen
            },
          ),
          // Export functionality
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Export As'),
            onTap: () {
              // Handle export functionality (e.g., export data to PDF)
              Navigator.pop(context); // Close the drawer
            },
          ),
          // Navigate to TodayTasks screen
          ListTile(
            leading: Icon(Icons.check_circle),
            title: Text('Today\'s Tasks'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodayTaskPage()),
              ); // Navigate to TodayTaskPage screen
            },
          ),
          // Navigate to Favorites screen
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorites'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              ); // Navigate to Favorites screen
            },
          ),
        ],
      ),
    );
  }
}
