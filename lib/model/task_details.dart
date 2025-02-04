class TaskDetails {
  final String title;
  final String category;
  final String description;
  final String createdBy;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isCompleted;

  const TaskDetails( {
    required this.title,
    required this.category,
    required this.description,
    required this.createdBy,
    required this.startTime,
    this.endTime,
    this.isCompleted = false,
  });

  TaskDetails copyWith({required bool isCompleted}) {
    return TaskDetails(
      title: title,
      category: category,
      description: description,
      createdBy: createdBy,
      startTime: startTime,
      endTime: endTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}