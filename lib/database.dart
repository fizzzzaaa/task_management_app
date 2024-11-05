import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task_model.dart'; // Import your TaskModel

class DatabaseHelper {
  static const String _boxName = 'tasks';

  /// Initializes Hive and opens the tasks box.
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter()); // Register the TaskModel adapter
    await Hive.openBox<TaskModel>(_boxName); // Open a box to store tasks
  }

  /// Retrieves the tasks box.
  static Box<TaskModel> getTasksBox() {
    return Hive.box<TaskModel>(_boxName);
  }

  /// Adds a new task to the tasks box.
  static Future<void> addTask(TaskModel task) async {
    final box = getTasksBox();
    await box.add(task); // Add the new task to the Hive box
  }

  /// Retrieves all tasks from the tasks box.
  static List<TaskModel> getAllTasks() {
    final box = getTasksBox();
    return box.values.toList(); // Return all tasks as a List
  }

  /// Retrieves a task by index from the tasks box.
  static TaskModel? getTask(int index) {
    final box = getTasksBox();
    return box.getAt(index); // Retrieve a specific task
  }

  /// Deletes a task by index from the tasks box.
  static Future<void> deleteTask(int index) async {
    final box = getTasksBox();
    await box.deleteAt(index); // Delete the task at the specified index
  }

  /// Updates a task in the tasks box.
  static Future<void> updateTask(int index, TaskModel task) async {
    final box = getTasksBox();
    await box.putAt(index, task); // Update the task at the specified index
  }

  /// Clears all tasks from the tasks box.
  static Future<void> clearTasks() async {
    final box = getTasksBox();
    await box.clear(); // Clear all tasks from the box
  }
}
