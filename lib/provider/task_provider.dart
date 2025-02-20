import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../model/task_category.dart';
import '../model/task_details.dart';

/*
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
 */


class TaskProvider extends ChangeNotifier {
  // Implement a database
  FirebaseFirestore _db = FirebaseFirestore.instance;
  List<TaskDetails> _tasks = [];

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

  // Get Tasks
  List<TaskDetails> get tasks => _tasks;

  // Get Ongoing Tasks (Tasks that have started but are not completed)
  List<TaskDetails> get ongoingTasks =>
      _tasks
          .where((task) =>
      (task.startTime ?? task.endTime).isBefore(DateTime.now()) &&
          !task.isCompleted)
          .toList();

  // Get Upcoming Tasks (Tasks that are scheduled for later)
  List<TaskDetails> get upcomingTasks =>
      _tasks
          .where((task) =>
      (task.startTime ?? task.endTime).isAfter(DateTime.now()) &&
          !task.isCompleted)
          .toList();

  // Get Task Count by Category
  int getTaskCount(String categoryTitle) {
    return _tasks
        .where((task) => task.category == categoryTitle)
        .length;
  }

  // Add a New Task to Firestore
  Future<void> addTask(String title, String category, String description,
      String createdBy, DateTime endTime, [DateTime? startTime]) async {
    final newTask = TaskDetails(
        id: Random().nextInt(10000).toString(),
        // Generate random ID
        title: title,
        category: category,
        description: description,
        createdBy: createdBy,
        startTime: startTime,
        endTime: endTime
    );

    await _db.collection('task').doc(newTask.id).set({
      'id': newTask.id,
      'title': newTask.title,
      'category': newTask.category,
      'description': newTask.description,
      'createdBy': newTask.createdBy,
      'startTime': newTask.startTime?.toIso8601String(),
      'endTime': newTask.endTime.toIso8601String(),
      'isCompleted': newTask.isCompleted,
    });
    /**
        _tasks.add(newTask);
        notifyListeners();
     */
  }

  // Update Task Completion Status
  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    /**
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isCompleted: isCompleted);
      notifyListeners();
    }
     */
    await _db.collection('task').doc(taskId).update({'isCompleted' : isCompleted});
    notifyListeners();
  }

  //  Delete a Task
  Future<void> deleteTask(String taskId) async {
    //_tasks.removeWhere((task) => task.id == taskId);
    await _db.collection('task').doc(taskId).delete();
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
      final endTime = (task.startTime ?? task.endTime).add(const Duration(minutes: 30)); //  Default 30 min duration
      return (task.startTime ?? task.endTime).isBefore(now) && endTime.isAfter(now);
    }).toList();
  }
  
  List<TaskDetails> getUpcomingTasks() {
    final now = DateTime.now();
    return _tasks.where((task) => (task.startTime ?? task.endTime).isAfter(now)).toList();
  }

  void changeCompletion(String id) {
    var taskList = _tasks.where((TaskDetails task) => task.id == id).toList();
    if (taskList.isNotEmpty){
      TaskDetails task = taskList[0];
      task.isCompleted = !task.isCompleted;
    }
  }

  List<TaskDetails> getTasksForDate(DateTime selectedDate) {
    return _tasks.where((task) {
      return (task.startTime ?? task.endTime).year == selectedDate.year &&
          (task.startTime ?? task.endTime).month == selectedDate.month &&
          (task.startTime ?? task.endTime).day == selectedDate.day;
    }).toList();
  }

  //Fetch Tasks from Firestore Live Stream
  void fetchTasks() {
    _db.collection('task').snapshots().listen((snapshot) {
      _tasks = snapshot.docs.map((doc) => TaskDetails.fromMap(doc.data())).toList();
      notifyListeners();
    });
  }
}
