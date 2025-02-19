class TaskDetails {
  final String id;
  final String title;
  final String category;
  final String description;
  final String createdBy;
  final DateTime endTime;
  final DateTime? startTime;
  bool isCompleted;

  TaskDetails( {
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.createdBy,
    required this.endTime,
    this.startTime,
    this.isCompleted = false,
  });

  factory TaskDetails.fromMap(Map data){
    return TaskDetails(
     id: data['id'],
     title: data['title'],
     category: data['category'],
     description: data['description'],
     createdBy: data['createdBy'],
     startTime: DateTime.tryParse(data['startTime']),
     endTime: DateTime.parse(data['endTime'])
    );
  }

  TaskDetails copyWith({required bool isCompleted}) {
    return TaskDetails(
      id : id,
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