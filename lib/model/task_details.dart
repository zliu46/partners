class TaskDetails {
  final String title;
  final String category;
  final String description;
  final String createdBy;
  final DateTime? dateTime;

  const TaskDetails({
    required this.title,
    required this.category,
    required this.description,
    required this.createdBy,
    this.dateTime
  });
}