import 'dart:ui';

class TaskCategory{
  final String name;
  final Color color;
  const TaskCategory(this.name, this.color);

  @override
  String toString(){
    return name;
  }
}