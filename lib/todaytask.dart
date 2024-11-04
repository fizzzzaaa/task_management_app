import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
 // This line should be at the top

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String date;
  @HiveField(2)
  final String time;
  @HiveField(3)
  bool isFavorite;
  @HiveField(4)
  bool isCompleted;

  Task({required this.title, required this.date, required this.time, this.isFavorite = false, this.isCompleted = false});
}

class TodayTaskPage extends StatefulWidget {
  @override
  _TodayTaskPageState createState() => _TodayTaskPageState();
}

class _TodayTaskPageState extends State<TodayTaskPage> {
  List<Task> tasks = []; // Use List<Task> instead of List<Map<String, dynamic>>
  final Box<Task> _taskBox = Hive.box<Task>('tasks');

  @override
  void initState() {
    super.initState();
    _loadTasksFromDatabase(); // Load tasks on initialization
  }

  Future<void> _loadTasksFromDatabase() async {
    setState(() {
      tasks = _taskBox.values.toList(); // Get tasks from the Hive box
    });
  }

  void _addTask(String taskName, String date, String time) {
    final newTask = Task(title: taskName, date: date, time: time);
    _taskBox.add(newTask); // Add the task to the Hive box
    _loadTasksFromDatabase(); // Reload tasks after addition
  }

  // Function to delete a task from the database and refresh the task list
  void _deleteTask(int index) {
    _taskBox.deleteAt(index); // Delete task from Hive
    _loadTasksFromDatabase(); // Refresh task list
  }

  // Function to show the input modal for adding a new task
  void _showTaskInputModal() {
    String taskName = '';
    String? date;
    String? time;

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
                  title: Text(date ?? 'Date', style: TextStyle(fontSize: 16)),
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
                  title: Text(time ?? 'Time', style: TextStyle(fontSize: 16)),
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (taskName.isNotEmpty && date != null && time != null) {
                      _addTask(taskName, date!, time!);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to show the edit modal for updating a task
  void _showEditTaskModal(int index) {
    String taskName = tasks[index].title;
    String? date = tasks[index].date;
    String? time = tasks[index].time;

    TextEditingController taskNameController = TextEditingController(text: taskName);

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
                  controller: taskNameController,
                  decoration: InputDecoration(labelText: 'Task Name'),
                  onChanged: (value) {
                    taskName = value;
                  },
                ),
                ListTile(
                  title: Text(date ?? 'Date', style: TextStyle(fontSize: 16)),
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
                  title: Text(time ?? 'Time', style: TextStyle(fontSize: 16)),
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (taskNameController.text.isNotEmpty && date != null && time != null) {
                      final updatedTask = Task(
                        title: taskNameController.text,
                        date: date!, // Use ! to assert that date is not null
                        time: time!, // Use ! to assert that time is not null
                        isFavorite: tasks[index].isFavorite,
                        isCompleted: tasks[index].isCompleted,
                      );
                      _taskBox.putAt(index, updatedTask); // Update task in Hive
                      _loadTasksFromDatabase();
                      Navigator.pop(context);
                    } else {
                      // Optionally, show an error message if date or time is null
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill in all fields.')),
                      );
                    }
                  },
                  child: Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  // Dropdown menu for each task with options
  Widget _buildTaskMenu(int index) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'Edit') {
          _showEditTaskModal(index);
        } else if (value == 'Delete') {
          _deleteTask(index);
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'Edit',
            child: Text('Edit'),
          ),
          PopupMenuItem(
            value: 'Delete',
            child: Text('Delete'),
          ),
        ];
      },
    );
  }

  // Build method for rendering UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Tasks'),
        backgroundColor: Colors.brown[800],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(tasks[index].title),
              subtitle: Text('${tasks[index].date} at ${tasks[index].time}'),
              trailing: _buildTaskMenu(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskInputModal,
        child: Icon(Icons.add),
        backgroundColor: Colors.brown[800],
      ),
    );
  }
}
