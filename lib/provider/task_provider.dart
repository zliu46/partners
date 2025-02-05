import 'dart:math';
import 'package:flutter/material.dart';
import '../model/task_category.dart';
import '../model/task_details.dart';

class TaskProvider extends ChangeNotifier {
  final List<TaskDetails> _tasks = [
    TaskDetails(
      id : '1',
      title: "Feed the baby",
      category: "Baby",
      description: "Heat up the milk in a bottle then feed the baby.",
      createdBy: "Samantha",
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(minutes: 15)),
    ),
    TaskDetails(
      id : '2',
      title: "Diaper Change",
      category: "Baby",
      description: "Change the baby's diaper.",
      createdBy: "Samantha",
      startTime: DateTime.now().add(const Duration(hours: 1)),
    ),
    TaskDetails(
      id : '3',
      title: "Pump Milk",
      category: "Baby",
      description: "Pump milk for baby feeding.",
      createdBy: "Sarah",
      startTime: DateTime.now().add(const Duration(hours: 2)),
    ),
    TaskDetails(
      id : '4',
      title: "Baby Bath",
      category: 'Baby',
      description: "Give the baby a warm bath before bedtime.",
      createdBy: "Sarah",
      startTime: DateTime.now().add(const Duration(hours: 6)),
    ),
  ];

  final List<TaskCategory> _categories = [
    TaskCategory(title: "Baby", color: Colors.amber[200]!),
    TaskCategory(title: "Chores", color: Colors.green[200]!),
    TaskCategory(title: "Groceries", color: Colors.purple[200]!),
    TaskCategory(title: "Appointment", color: Colors.grey[300]!),
  ];

  List<TaskDetails> getTasksByCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  // Get Categories
  List<TaskCategory> get categories => _categories;

  // Get Ongoing Tasks (Tasks that have started but are not completed)
  List<TaskDetails> get ongoingTasks => _tasks
      .where((task) => task.startTime.isBefore(DateTime.now()) && !task.isCompleted)
      .toList();

  // Get Upcoming Tasks (Tasks that are scheduled for later)
  List<TaskDetails> get upcomingTasks => _tasks
      .where((task) => task.startTime.isAfter(DateTime.now()) && !task.isCompleted)
      .toList();

  // Get Task Count by Category
  int getTaskCount(String categoryTitle) {
    return _tasks.where((task) => task.category == categoryTitle).length;
  }

  // Add a New Task
  void addTask(String title, String category, String description, String createdBy, DateTime startTime) {
    final newTask = TaskDetails(
      id: Random().nextInt(10000).toString(), // Generate random ID
      title: title,
      category: category,
      description: description,
      createdBy: createdBy,
      startTime: startTime,
    );
    _tasks.add(newTask);
    notifyListeners();
  }

  // Update Task Completion Status
  void updateTaskCompletion(String taskId, bool isCompleted) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isCompleted: isCompleted);
      notifyListeners();
    }
  }

  //  Delete a Task
  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  //  Add a New Category (if needed)
  void addCategory(String title, Color color) {
    categories.add(TaskCategory(title: title, color: color));
    notifyListeners();
  }

  List<TaskDetails> getOngoingTasks() {
    final now = DateTime.now();
    return _tasks.where((task) {
      final endTime = task.endTime ?? task.startTime.add(const Duration(minutes: 30)); //  Default 30 min duration
      return task.startTime.isBefore(now) && endTime.isAfter(now);
    }).toList();
  }
  
  List<TaskDetails> getUpcomingTasks() {
    final now = DateTime.now();
    return _tasks.where((task) => task.startTime.isAfter(now)).toList();
  }
}
