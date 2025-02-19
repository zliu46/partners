import 'dart:ui';

class TaskCategory{
  final String title;
  final Color color;

  TaskCategory({required this.title, required this.color});

  factory TaskCategory.fromMap(Map data){
    return TaskCategory(
      title: data['title'],
      color: data['color']
    );
  }

  @override
  String toString(){
    return title;
  }
}