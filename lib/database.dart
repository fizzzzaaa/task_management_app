import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'task_model.dart'; // Import your TaskModel

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        date TEXT,
        time TEXT,
        repeatDay TEXT,
        isFavorite INTEGER,
        isCompleted INTEGER
      )
    ''');
  }

  // Method to get all tasks
  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return TaskModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        date: maps[i]['date'],
        time: maps[i]['time'],
        repeatDay: maps[i]['repeatDay'],
        isFavorite: maps[i]['isFavorite'] == 1,
        isCompleted: maps[i]['isCompleted'] == 1,
      );
    });
  }

  // Method to insert a new task
  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
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
}
