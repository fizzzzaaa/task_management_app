import 'package:flutter/material.dart';
import 'completed_screen.dart'; // Example of another screen you may navigate to
import 'notif.dart'; // Import the notif.dart file for notifications screen

class MenuDrawer extends StatelessWidget {
  final Function toggleTheme; // The toggleTheme function will be passed from the parent widget

  // Constructor to receive the toggleTheme function
  MenuDrawer({required this.toggleTheme});

  // Function to show the export message after selecting an option
  void showExportMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Export Status"),
          content: Text(message),
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
              // Close the drawer before showing the notification
              Navigator.pop(context);

              // Show task notification when the button is pressed
              showTaskNotification(context, "This is your task notification!", duration: Duration(seconds: 3));
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
          // Export functionality
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Export As'),
            onTap: () {
              // Close the drawer
              Navigator.pop(context);

              // Show the dialog to select export type (PDF or CSV)
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Select Export Option"),
                    content: Text("Choose whether you want to export as PDF or CSV."),
                    actions: <Widget>[
                      // Export as PDF
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent, // Transparent background
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                          side: BorderSide(color: Colors.blue), // Optional: border color
                        ),
                        icon: Icon(Icons.picture_as_pdf, color: Colors.blue), // PDF Icon
                        label: Text("Export as PDF", style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          // Handle PDF export logic here
                          Navigator.pop(context); // Close the dialog
                          showExportMessage(context, "Exporting as PDF...");
                          // Add your PDF export logic here
                        },
                      ),
                      SizedBox(height: 10),
                      // Export as CSV
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent, // Transparent background
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                          side: BorderSide(color: Colors.green), // Optional: border color
                        ),
                        icon: Icon(Icons.table_chart, color: Colors.green), // CSV Icon
                        label: Text("Export as CSV", style: TextStyle(color: Colors.green)),
                        onPressed: () {
                          // Handle CSV export logic here
                          Navigator.pop(context); // Close the dialog
                          showExportMessage(context, "Exporting as CSV...");
                          // Add your CSV export logic here
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
