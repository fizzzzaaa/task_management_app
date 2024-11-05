// task_model.dart
class Task {
  final int? id; // Use nullable int for ID
  final String title;
  final String date;
  final String time;

  Task({
    this.id,
    required this.title,
    required this.date,
    required this.time,
  });

  // Convert a Task into a Map. The Map is used as a JSON-like structure.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
    };
  }

  // Convert a Map into a Task. This is the reverse of the above.
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
    );
  }
}
