import 'package:flutter/material.dart';
import 'completed_screen.dart'; // Example of another screen you may navigate to

class MenuDrawer extends StatelessWidget {
  final Function toggleTheme; // The toggleTheme function will be passed from the parent widget

  // Constructor to receive the toggleTheme function
  MenuDrawer({required this.toggleTheme});

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
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white), // Back arrow icon
                  onPressed: () {
                    Navigator.pop(context); // Close the drawer when clicked
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
              value: Theme.of(context).brightness == Brightness.dark, // Check if current theme is dark
              onChanged: (value) {
                toggleTheme(); // Call the toggle theme function passed from parent
              },
            ),
          ),
          // Notifications button
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              // Handle navigation to notifications screen
              Navigator.pop(context); // Close the drawer for now
              // Navigate to a Notifications screen if needed
            },
          ),
          // Navigate to CompletedScreen (Progress tracking)
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Progress'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompletedScreen(toggleTheme: toggleTheme)),
              ); // Navigate to progress tracking screen
            },
          ),
          // Export functionality (dummy for now)
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
