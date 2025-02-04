import 'package:flutter/material.dart';
import '../model/task_details.dart';

class TaskProvider extends ChangeNotifier {
  final List<TaskDetails> _tasks = [
    TaskDetails(
      title: "Feed the baby",
      category: "Baby",
      description: "Heat up the milk in a bottle then feed the baby.",
      createdBy: "Samantha",
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(minutes: 15)),
    ),
    TaskDetails(
      title: "Diaper Change",
      category: "Baby",
      description: "Change the baby's diaper.",
      createdBy: "Samantha",
      startTime: DateTime.now().add(const Duration(hours: 1)),
    ),
    TaskDetails(
      title: "Pump Milk",
      category: "Baby",
      description: "Pump milk for baby feeding.",
      createdBy: "Sarah",
      startTime: DateTime.now().add(const Duration(hours: 2)),
    ),
    TaskDetails(
      title: "Baby Bath",
      category: "Baby",
      description: "Give the baby a warm bath before bedtime.",
      createdBy: "Sarah",
      startTime: DateTime.now().add(const Duration(hours: 6)),
    ),
  ];

  List<TaskDetails> get babyTasks => _tasks.where((task) => task.category == "Baby").toList();

  void addTask(TaskDetails task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTaskCompletion(TaskDetails task, bool isCompleted) {
    final index = _tasks.indexWhere((t) => t.title == task.title);
    if (index != -1) {
      _tasks[index] = task.copyWith(isCompleted: isCompleted);
      notifyListeners();
    }
  }
}
