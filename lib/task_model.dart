class TaskModel {
  final int? id; // Nullable for new tasks that haven't been inserted yet
  final String title;
  final String date;
  final String time;
  final String repeatDay;
  final bool isFavorite;
  final bool isCompleted;

  TaskModel({
    this.id,
    required this.title,
    required this.date,
    required this.time,
    this.repeatDay = '',
    this.isFavorite = false,
    this.isCompleted = false,
  });

  // Convert a TaskModel into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'repeatDay': repeatDay,
      'isFavorite': isFavorite ? 1 : 0,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Extract a TaskModel from a Map object
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      time: map['time'],
      repeatDay: map['repeatDay'],
      isFavorite: map['isFavorite'] == 1,
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
