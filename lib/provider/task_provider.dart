import 'dart:ffi';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../model/task_category.dart';
import '../model/task_details.dart';
import 'auth_service.dart';
import 'database_service.dart';

class TaskProvider extends ChangeNotifier {
  // Implement a database
  final DatabaseService _db = DatabaseService();
  final AuthService _auth = AuthService();
  List<TaskDetails> _tasks = [];

  late UserCredential user;
  // document id for current partnership, set with .setPartnership()
  String currentPartnership = 'LeBWuVnd6MLOptvU9Yc0'; //hard code for now

  void setUser(UserCredential user) {
    user = user;
  }

  void setCurrentPartnership(String partnershipId) {
    currentPartnership = partnershipId;
  }

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
  List<TaskDetails> get ongoingTasks => _tasks
      .where((task) =>
          (task.startTime ?? task.endTime).isBefore(DateTime.now()) &&
          !task.isCompleted)
      .toList();

  // Get Upcoming Tasks (Tasks that are scheduled for later)
  List<TaskDetails> get upcomingTasks => _tasks
      .where((task) =>
          (task.startTime ?? task.endTime).isAfter(DateTime.now()) &&
          !task.isCompleted)
      .toList();

  // Get Task Count by Category
  int getTaskCount(String categoryTitle) {
    return _tasks.where((task) => task.category == categoryTitle).length;
  }

  // Add a New Task to Firestore
  Future<void> addTask(String title, String category, String description,
      String createdBy, DateTime endTime,
      [DateTime? startTime]) async {
    Map<String, dynamic> data = {
      'title': title,
      'category': category,
      'description': description,
      'createdBy': createdBy,
      'startTime': startTime,
      'endTime': endTime,
      'isCompleted': false,
    };

    String id = await _db.addTask(data, currentPartnership);
    data['id'] = id;
    _tasks.add(TaskDetails.fromMap(data));
    notifyListeners();
  }

  // Update Task Completion Status
  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    _db.updateCompletion(taskId, currentPartnership);

    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isCompleted: isCompleted);
      notifyListeners();
    }
    notifyListeners();
  }

  //  Delete a Task
  Future<void> deleteTask(String taskId) async {
    _db.deleteTask(taskId, currentPartnership);
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  //  Add a New Category (if needed)
  void addCategory(String title, Color color) {
    categories.add(TaskCategory(title: title, color: color));
    _db.addCategory({'name': title, 'color': color}, currentPartnership);
    notifyListeners();
  }

  List<TaskDetails> getOngoingTasks() {
    final now = DateTime.now();
    return _tasks.where((task) {
      final endTime = (task.startTime ?? task.endTime)
          .add(const Duration(minutes: 30)); //  Default 30 min duration
      return (task.startTime ?? task.endTime).isBefore(now) &&
          endTime.isAfter(now);
    }).toList();
  }

  List<TaskDetails> getUpcomingTasks() {
    final now = DateTime.now();
    return _tasks
        .where((task) => (task.startTime ?? task.endTime).isAfter(now))
        .toList();
  }

  void changeCompletion(String id) {
    var taskList = _tasks.where((TaskDetails task) => task.id == id).toList();
    if (taskList.isNotEmpty) {
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
    _db.fetchTasksStream(currentPartnership).listen((taskList) {
      _tasks = taskList;
      notifyListeners();
    });
  }

  Future<bool> checkUsernameTaken(String username) async {
    return await _db.checkUsernameTaken(username);
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signIn(email, password);
  }

  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.signUp(email, password);
  }

  void addUser(String username, String email, String first_name,
      String last_name, String uid) {
    _db.addUser(username, email, first_name, last_name, uid);
  }
}
