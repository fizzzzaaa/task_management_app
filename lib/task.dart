import 'package:hive/hive.dart';
// This will be generated after running build_runner

@HiveType(typeId: 0) // Unique identifier for the Task type
class TaskModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final String time;

  @HiveField(3)
  final bool isFavorite;

  @HiveField(4)
  final bool isCompleted;

  // Updated constructor
  TaskModel({
    required this.title,
    required this.date,
    required this.time,
    this.isFavorite = false,
    this.isCompleted = false,
  });
}

// Define the TaskAdapter for Hive
class TaskAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    return TaskModel(
      title: reader.read() as String,
      date: reader.read() as String,
      time: reader.read() as String,
      isFavorite: reader.read() as bool,
      isCompleted: reader.read() as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel task) {
    writer.write(task.title);
    writer.write(task.date);
    writer.write(task.time);
    writer.write(task.isFavorite);
    writer.write(task.isCompleted);
  }
}
