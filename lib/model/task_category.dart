import 'dart:ui';

class TaskCategory{
  final String title;
  final Color color;
  const TaskCategory({required this.title, required this.color});

  @override
  String toString(){
    return title;
  }
}