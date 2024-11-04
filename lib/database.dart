import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Table and column names
  final String tableName = 'tasks';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnDescription = 'description';

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT
      )
    ''');
  }

  // Insert a new task
  Future<int> insertTask(Map<String, dynamic> task) async {
    Database db = await database;
    return await db.insert(tableName, task);
  }

  // Retrieve all tasks
  Future<List<Map<String, dynamic>>> getTasks() async {
    Database db = await database;
    return await db.query(tableName);
  }

  // Delete a task
  Future<int> deleteTask(int id) async {
    Database db = await database;
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}
