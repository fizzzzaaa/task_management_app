class TaskModel {
  final int? id; // Add an ID for database purposes
  final String title;
  final String date;
  final String time;
  final bool isFavorite;
  final bool isCompleted;

  // Updated constructor
  TaskModel({
    this.id, // Make ID optional
    required this.title,
    required this.date,
    required this.time,
    this.isFavorite = false,
    this.isCompleted = false,
  });

  // Convert a TaskModel into a Map. The Map is used as a JSON object.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'isFavorite': isFavorite ? 1 : 0, // Convert bool to int for SQLite
      'isCompleted': isCompleted ? 1 : 0, // Convert bool to int for SQLite
    };
  }

  // Extract a TaskModel object from a Map
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      time: map['time'],
      isFavorite: map['isFavorite'] == 1, // Convert int back to bool
      isCompleted: map['isCompleted'] == 1, // Convert int back to bool
    );
  }
}
