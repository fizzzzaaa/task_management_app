import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'task_model.dart';
import 'menu.dart';// Assuming you have this model for tasks

class DatabaseHelper {
  static Database? _database;

  // Singleton pattern for database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initializeDatabase() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, 'tasks.db'); // Path to your SQLite database
      print('Database path: $path'); // Log the database path

      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE tasks (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              date TEXT,
              time TEXT,
              isFavorite INTEGER,
              isCompleted INTEGER,
              repeat TEXT
            )
          ''');
          print('Database created');
        },
      );
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  // Fetch all tasks
  Future<List<Task>> fetchTasks() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> taskMaps = await db.query('tasks');
      print('Fetched tasks: ${taskMaps.length}'); // Log the fetched tasks count

      return List.generate(taskMaps.length, (i) {
        return Task(
          id: taskMaps[i]['id'],
          title: taskMaps[i]['title'],
          date: taskMaps[i]['date'],
          time: taskMaps[i]['time'],
          isFavorite: taskMaps[i]['isFavorite'] == 1,
          isCompleted: taskMaps[i]['isCompleted'] == 1,
          repeat: taskMaps[i]['repeat'],
        );
      });
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  // Insert task
  Future<void> insertTask(Task task) async {
    try {
      final db = await database;
      await db.insert(
        'tasks',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Task inserted: ${task.title}');
    } catch (e) {
      print('Error inserting task: $e');
    }
  }

  // Delete task
  Future<void> deleteTask(int id) async {
    try {
      final db = await database;
      await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
      print('Task deleted with id: $id');
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  // Update task
  Future<void> updateTask(Task task) async {
    try {
      final db = await database;
      await db.update(
        'tasks',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      print('Task updated: ${task.title}');
    } catch (e) {
      print('Error updating task: $e');
    }
  }
}
