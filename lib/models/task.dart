class Task {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.isCompleted,
  });

  Map<String, String> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description ?? '',
      'isCompleted': isCompleted.toString(),
    };
  }

  factory Task.fromMap(Map<String, Object?> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] as String == 'true' ? true : false,
    );
  }
}
