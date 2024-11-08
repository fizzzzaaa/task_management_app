import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todaytask.dart'; // Import the TodayTaskPage to navigate to it
import 'completed_screen.dart'; // Example of another screen you may navigate to

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the theme state from the Provider
    final isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: TodayTaskPage(),
    );
  }
}

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Accessing the current theme state using Provider
    bool isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

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
                // Toggle the theme state using the ThemeNotifier
                Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
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

class TodayTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Today\'s Tasks')),
      body: Center(
        child: Text('Tasks for today will be displayed here'),
      ),
      drawer: MenuDrawer(),
    );
  }
}

class CompletedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Completed Tasks')),
      body: Center(
        child: Text('Completed tasks will be displayed here'),
      ),
    );
  }
}
