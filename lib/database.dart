// database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            date TEXT,
            time TEXT,
            isFavorite INTEGER,
            isCompleted INTEGER
          )
          ''',
        );
      },
      version: 1,
    );
  }

  // Method to insert a new task
  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.insert('tasks', task);
  }

  // Method to retrieve all tasks
  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query('tasks');
  }

  // Method to update a task
  Future<void> updateTask(Map<String, dynamic> task) async {
    final db = await database;
    await db.update(
      'tasks',
      task,
      where: 'id = ?',
      whereArgs: [task['id']],
    );
  }

  // Method to delete a task
  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Method to retrieve tasks marked as favorite
  Future<List<Map<String, dynamic>>> getFavoriteTasks() async {
    final db = await database;
    return await db.query(
      'tasks',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
  }

  // Method to retrieve completed tasks
  Future<List<Map<String, dynamic>>> getCompletedTasks() async {
    final db = await database;
    return await db.query(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [1],
    );
  }
}
