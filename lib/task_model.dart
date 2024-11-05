import 'package:hive/hive.dart';

// Define the TaskModel class
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

  TaskModel({
    required this.title,
    required this.date,
    required this.time,
    this.isFavorite = false,
    this.isCompleted = false,
  });
}

// Define the TaskModelAdapter for Hive
class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    return TaskModel(
      title: reader.readString(),
      date: reader.readString(),
      time: reader.readString(),
      isFavorite: reader.readBool(),
      isCompleted: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel task) {
    writer.writeString(task.title);
    writer.writeString(task.date);
    writer.writeString(task.time);
    writer.writeBool(task.isFavorite);
    writer.writeBool(task.isCompleted);
  }
}
