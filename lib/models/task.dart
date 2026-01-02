class Task {
  final String id;
  String title;
  String description;
  String priority; // 'Low', 'Medium', 'High'
  bool isCompleted;
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Task.create({
    required String title,
    required String description,
    required String priority,
  }) {
    return Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      priority: priority,
      isCompleted: false,
    );
  }
}