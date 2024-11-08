import 'package:flutter/material.dart';
import 'todaytask.dart'; // Import the TodayTaskPage to navigate to it
import 'completed_screen.dart'; // Example of another screen you may navigate to

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Accessing the state of MyApp to toggle theme
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple[800], // Matching theme color
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white), // Back arrow icon
                  onPressed: () {
                    // Navigate to TodayTaskPage when the back arrow is clicked
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TodayTaskPage()),
                    );
                  },
                ),
                SizedBox(width: 10), // Some spacing between the icon and the text
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          // Theme switcher
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Theme'),
            trailing: Switch(
              value: isDarkMode, // Use the current theme state to update switch
              onChanged: (value) {
                // Change the theme mode using the setState in MyApp
                final appState = context.findAncestorStateOfType<_MyAppState>();
                appState?.setState(() {
                  appState._isDarkMode = value;
                });
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
        ],
      ),
    );
  }
}
