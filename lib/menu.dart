import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Theme'),
            trailing: Switch(
              value: false,
              onChanged: (value) {
                // Handle theme change
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              // Handle notifications setting
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Progress'),
            onTap: () {
              // Handle progress tracking
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Export As'),
            onTap: () {
              // Handle export functionality
            },
          ),
        ],
      ),
    );
  }
}
