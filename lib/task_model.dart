class Task {
  int? id;
  String title;
  String date;
  String time;
  String repeat;
  bool isFavorite;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.repeat,
    this.isFavorite = false,  // Default value for isFavorite
    this.isCompleted = false, // Default value for isCompleted
  });

  // Convert a Task object into a Map to store in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'repeat': repeat,
      'isFavorite': isFavorite ? 1 : 0,  // Store as integer in database
      'isCompleted': isCompleted ? 1 : 0,  // Store as integer in database
    };
  }

  // Convert a Map into a Task object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      time: map['time'],
      repeat: map['repeat'],
      isFavorite: map['isFavorite'] == 1,  // Convert from integer to bool
      isCompleted: map['isCompleted'] == 1,  // Convert from integer to bool
    );
  }
}
