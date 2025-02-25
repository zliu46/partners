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
    required this.isCompleted,
    this.startTime,
  });

  factory TaskDetails.fromMap(Map data){
    return TaskDetails(
     id: data['id'],
     title: data['title'],
     category: data['category'],
     description: data['description'],
     createdBy: data['createdBy'],
     startTime: data['startTime'],
     endTime: data['endTime'],
      isCompleted: data['isCompleted']
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
      isCompleted: isCompleted
    );
  }
  void changeCompletion(){
    isCompleted = !isCompleted;
  }
  toString(){
    return "$id $title $category $description $isCompleted";
  }
}