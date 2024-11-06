class Task {
  final int? id;
  final String title;
  final String date;
  final String time;
  final bool isFavorite;
  final bool isCompleted;
  final String repeat; // New repeat field

  Task({
    this.id,
    required this.title,
    required this.date,
    required this.time,
    this.isFavorite = false,
    this.isCompleted = false,
    this.repeat = 'Never', // Default value
  });

  // Convert Task to Map (for SQFlite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'isFavorite': isFavorite ? 1 : 0,
      'isCompleted': isCompleted ? 1 : 0,
      'repeat': repeat, // Include repeat field
    };
  }

  // Convert Map to Task (from SQFlite)
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      time: map['time'],
      isFavorite: map['isFavorite'] == 1,
      isCompleted: map['isCompleted'] == 1,
      repeat: map['repeat'], // Handle repeat field
    );
  }
}
