import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'task_model.dart'; // Assuming you have this model for tasks

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
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'tasks.db'); // Path to your SQLite database

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
      },
    );
  }

  // Fetch all tasks
  Future<List<Task>> fetchTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> taskMaps = await db.query('tasks');

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
  }

  // Insert task
  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete task
  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // Update task
  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}
