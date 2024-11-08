import 'package:flutter/material.dart';
import 'database.dart'; // Import the database helper
import 'task_model.dart'; // Import the Task model
import 'favorites_screen.dart';
import 'completed_screen.dart';
import 'calendar_screen.dart';
import 'menu.dart'; // Import your Menu screen

class TodayTaskPage extends StatefulWidget {
  @override
  _TodayTaskPageState createState() => _TodayTaskPageState();
}

class _TodayTaskPageState extends State<TodayTaskPage> {
  List<Task> tasks = []; // List to hold tasks retrieved from the database
  int _selectedIndex = 0; // Track the selected index for the bottom navigation bar

  @override
  void initState() {
    super.initState();
    _loadTasksFromDatabase(); // Load tasks on initialization
  }

  Future<void> _loadTasksFromDatabase() async {
    final dbHelper = DatabaseHelper(); // Create an instance of DatabaseHelper
    final allTasks = await dbHelper.fetchTasks(); // Get all tasks from the database
    setState(() {
      tasks = allTasks; // Update the tasks list with the fetched tasks
    });
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.5, // Show half of the screen height
        child: Menu(), // Display Menu from menu.dart
      ),
    );
  }

  // Toggle task favorite status
  void _toggleTaskFavorite(Task task) {
    final dbHelper = DatabaseHelper();
    task.isFavorite = !task.isFavorite;
    dbHelper.updateTask(task); // Update the task in the database
    setState(() {}); // Rebuild the UI to reflect the change
  }

  // Toggle task completion status
  void _toggleTaskCompletion(Task task) {
    final dbHelper = DatabaseHelper();
    task.isCompleted = !task.isCompleted;
    dbHelper.updateTask(task); // Update the task in the database
    setState(() {}); // Rebuild the UI to reflect the change
  }

  // Delete task by ID
  void _deleteTask(int taskId) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteTask(taskId); // Delete task from the database
    _loadTasksFromDatabase(); // Reload tasks to reflect the deletion
  }

  // Show the task input modal for adding a new task
  void _showTaskInputModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: TaskInputForm(onSave: (newTask) {
            final dbHelper = DatabaseHelper();
            dbHelper.insertTask(newTask); // Save the new task in the database
            _loadTasksFromDatabase(); // Reload tasks
            Navigator.pop(context); // Close the modal
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white, // Set the icon color to white
          ),
          onPressed: _showMenu, // Show the menu as a half-screen overlay
        ),
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
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(tasks[index].title),
              subtitle: Text('${tasks[index].date} at ${tasks[index].time}\nRepeats: ${tasks[index].repeat}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      tasks[index].isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: tasks[index].isFavorite ? Colors.deepPurple : Colors.blueGrey,
                    ),
                    onPressed: () {
                      _toggleTaskFavorite(tasks[index]);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      tasks[index].isCompleted ? Icons.library_add_check_rounded : Icons.library_add_check_outlined,
                      color: tasks[index].isCompleted ? Colors.deepPurple : Colors.deepPurple,
                    ),
                    onPressed: () {
                      _toggleTaskCompletion(tasks[index]);
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Delete') {
                        _deleteTask(tasks[index].id!); // Delete task by ID
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(value: 'Delete', child: Text('Delete')),
                      ];
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskInputModal,
        child: Icon(Icons.add),
        backgroundColor: Colors.purple[800],
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

  // Handle bottom navigation bar tap events
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class TaskInputForm extends StatelessWidget {
  final Function(Task) onSave;

  TaskInputForm({required this.onSave});

  @override
  Widget build(BuildContext context) {
    // Form for creating or editing a task
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Task Title'),
            onChanged: (value) {
              // Handle title change
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Date & Time'),
            onChanged: (value) {
              // Handle date & time change
            },
          ),
          ElevatedButton(
            onPressed: () {
              Task newTask = Task(title: 'New Task', date: '2024-11-08', time: '12:00 PM'); // Dummy task
              onSave(newTask);
            },
            child: Text('Save Task'),
          ),
        ],
      ),
    );
  }
}
