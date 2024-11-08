import 'package:flutter/material.dart';
import 'database.dart'; // Import your DatabaseHelper
import 'task_model.dart'; // Import your Task model
import 'todaytask.dart' as todaytask; // Use alias for todaytask.dart
import 'package:task_management_app/favorites_screen.dart' as favorites;
import 'package:task_management_app/completed_screen.dart';
import 'package:task_management_app/calendar_screen.dart';
import 'menu.dart'; // If required, keep this import
import 'notif.dart'; // Import the notification system

class FavoritesScreen extends StatefulWidget {
  final Function toggleTheme;

  FavoritesScreen({required this.toggleTheme});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Task> favoriteTasks = [];
  bool isLoading = true;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadFavoriteTasks();
  }

  Future<void> _loadFavoriteTasks() async {
    try {
      final dbHelper = DatabaseHelper();
      final tasks = await dbHelper.fetchTasks();
      setState(() {
        favoriteTasks = tasks.where((task) => task.isFavorite).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load favorite tasks.')),
      );
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });

    Widget targetScreen;
    switch (index) {
      case 0:
        targetScreen = todaytask.TodayTaskPage(toggleTheme: widget.toggleTheme);
        break;
      case 1:
        targetScreen = FavoritesScreen(toggleTheme: widget.toggleTheme);
        break;
      case 2:
        targetScreen = CompletedScreen(toggleTheme: widget.toggleTheme);
        break;
      case 3:
        targetScreen = CalendarScreen(toggleTheme: widget.toggleTheme);
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  Future<void> _deleteTask(int id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteTask(id);
    _loadFavoriteTasks();
    showTaskNotification('Task Deleted Successfully!');
  }

  Future<void> _completeTask(int id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.updateTaskCompletion(id, true); // Mark task as completed
    _loadFavoriteTasks();
    showTaskNotification('Task Marked as Completed!');
  }

  void _addNewTaskNotification() {
    showTaskNotification('New Task Added Successfully!');
  }

  void _showTaskOptionsMenu(Task task) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100.0, 100.0, 0.0, 0.0),
      items: [
        PopupMenuItem(value: 'edit', child: Text('Edit Task')),
        PopupMenuItem(value: 'complete', child: Text('Mark as Completed')),
        PopupMenuItem(value: 'delete', child: Text('Delete Task')),
      ],
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 'edit':
            showTaskNotification('Task Edited Successfully!');
            break;
          case 'complete':
            _completeTask(task.id!);
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
        backgroundColor: Colors.purple[800],
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favoriteTasks.isEmpty
          ? Center(child: Text('No favorite tasks available.'))
          : ListView.builder(
        itemCount: favoriteTasks.length,
        itemBuilder: (context, index) {
          final task = favoriteTasks[index];
          return ListTile(
            title: Text(
              task.title,
              style: TextStyle(color: Colors.purple[800]),
            ),
            subtitle: Text(
              '${task.date} at ${task.time}',
              style: TextStyle(color: Colors.purple[600]),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.purple[800],
              ),
              onPressed: () => _showTaskOptionsMenu(task),
            ),
          );
        },
      ),
      drawer: MenuDrawer(toggleTheme: widget.toggleTheme),
    );
  }

  Widget _buildNavButton(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
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
