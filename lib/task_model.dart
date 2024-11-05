// task_model.dart
class Task {
  final int? id; // Use nullable int for ID
  final String title;
  final String date;
  final String time;
  final bool isFavorite;
  final bool isCompleted;// Add isFavorite property

  Task({
    this.id,
    required this.title,
    required this.date,
    required this.time,
    this.isFavorite = false,
    this.isCompleted=false,
  });

  // Convert a Task into a Map. The Map is used as a JSON-like structure.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'isFavorite': isFavorite,
      'isCompleted': isCompleted,// Include isFavorite in the map
    };
  }

  // Convert a Map into a Task. This is the reverse of the above.
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      isFavorite: map['isFavorite'] as bool? ?? false, // Default to false if not present
    );
  }
}
