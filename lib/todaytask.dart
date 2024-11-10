import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'database.dart';
import 'task_model.dart';
import 'favorites_screen.dart';
import 'completed_screen.dart';
import 'calendar_screen.dart';
import 'menu.dart';

class TodayTaskPage extends StatefulWidget {
  final Function toggleTheme;

  TodayTaskPage({required this.toggleTheme});

  @override
  _TodayTaskPageState createState() => _TodayTaskPageState();
}

class _TodayTaskPageState extends State<TodayTaskPage> {
  List<Task> tasks = [];
  int _selectedIndex = 0;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadTasksFromDatabase();
  }

  // Initialize notifications
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show notification with a custom message
  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      channelDescription: 'Notifications for task management',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, 'Task Manager', message, platformChannelSpecifics);
  }

  Future<void> _loadTasksFromDatabase() async {
    final dbHelper = DatabaseHelper();
    final allTasks = await dbHelper.fetchTasks();
    setState(() {
      tasks = allTasks;
    });
  }

  void _addTask(String taskName, String date, String time, String repeat) async {
    final newTask = Task(title: taskName, date: date, time: time, repeat: repeat, isFavorite: false, isCompleted: false);
    final dbHelper = DatabaseHelper();
    await dbHelper.insertTask(newTask);
    setState(() {
      tasks.add(newTask);
    });
    await _showNotification('New task added: $taskName');
  }

  void _deleteTask(int id, String taskName) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteTask(id);
    _loadTasksFromDatabase();
    await _showNotification('Task deleted: $taskName');
  }

  void _toggleFavorite(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      date: task.date,
      time: task.time,
      repeat: task.repeat,
      isFavorite: !task.isFavorite,
      isCompleted: task.isCompleted,
    );
    final dbHelper = DatabaseHelper();
    await dbHelper.insertTask(updatedTask);
    setState(() {
      task.isFavorite = updatedTask.isFavorite;
    });
    await _showNotification(task.isFavorite ? 'Marked as favorite: ${task.title}' : 'Removed from favorites: ${task.title}');
  }

  void _toggleCompleted(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      date: task.date,
      time: task.time,
      repeat: task.repeat,
      isFavorite: task.isFavorite,
      isCompleted: !task.isCompleted,
    );
    final dbHelper = DatabaseHelper();
    await dbHelper.insertTask(updatedTask);
    setState(() {
      task.isCompleted = updatedTask.isCompleted;
    });
    await _showNotification(task.isCompleted ? 'Task completed: ${task.title}' : 'Marked as incomplete: ${task.title}');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TodayTaskPage(toggleTheme: widget.toggleTheme)),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FavoritesScreen(toggleTheme: widget.toggleTheme)),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CompletedScreen(toggleTheme: widget.toggleTheme)),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CalendarScreen(toggleTheme: widget.toggleTheme)),
        );
        break;
    }
  }

  void _showTaskInputModal() {
    String taskName = '';
    String? date;
    String? time;
    String repeat = 'None';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Task Name'),
                  onChanged: (value) {
                    taskName = value;
                  },
                ),
                ListTile(
                  title: Text(date ?? 'Select Date', style: TextStyle(fontSize: 16)),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        date = DateFormat.yMMMMd().format(pickedDate);
                      });
                    }
                  },
                ),
                ListTile(
                  title: Text(time ?? 'Select Time', style: TextStyle(fontSize: 16)),
                  trailing: Icon(Icons.access_time),
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        time = pickedTime.format(context);
                      });
                    }
                  },
                ),
                ListTile(
                  title: Text("Repeat"),
                  trailing: DropdownButton<String>(
                    value: repeat,
                    items: ['None', 'Daily', 'Weekly', 'Monthly'].map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        repeat = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (taskName.isNotEmpty && date != null && time != null) {
                      _addTask(taskName, date!, time!, repeat);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[800],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(tasks[index].title),
              subtitle: Text('${tasks[index].date} at ${tasks[index].time} - ${tasks[index].repeat}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      tasks[index].isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: tasks[index].isFavorite ? Colors.purple : null,
                    ),
                    onPressed: () {
                      _toggleFavorite(tasks[index]);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      tasks[index].isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                      color: tasks[index].isCompleted ? Colors.purple : null,
                    ),
                    onPressed: () {
                      _toggleCompleted(tasks[index]);
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Delete') {
                        _deleteTask(tasks[index].id!, tasks[index].title);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      drawer: MenuDrawer(toggleTheme: widget.toggleTheme),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskInputModal,
        backgroundColor: Colors.purple[800],
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Colors.white : Colors.white70,
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Colors.white : Colors.white70,
              fontSize: 12, // Set the desired font size here (e.g., 10)
            ),
          ),
        ],
      ),
    );
  }

}
