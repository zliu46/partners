import 'dart:async';
import 'dart:ui';

import 'package:mockito/mockito.dart';
import 'package:partners/model/partnership.dart';
import 'package:partners/model/task_category.dart';
import 'package:partners/model/task_details.dart';
import 'package:partners/provider/task_provider.dart';

class MockTaskProvider extends Mock implements TaskProvider {

  @override
  late List<Partnership> partnerships;

  late Partnership _currentPartnership;

  late int _currentPartnershipIndex;
  @override
  int get currentPartnershipIndex => _currentPartnershipIndex;

  @override
  Future<void> setCurrentPartnership(int index) async {
    _currentPartnership = partnerships[index];
    _currentPartnershipIndex = index;
    notifyListeners();
  }


  @override
  List<TaskCategory> categories = [];

  @override
  List<TaskDetails> ongoingTasks = [];

  @override
  List<TaskDetails> upcomingTasks = [];

  @override
  String firstName = 'test';

  @override
  String username = 'testUser';
  @override
  List<TaskDetails> getOngoingTasks() {
    return [];
  }

  @override
  List<TaskDetails> getUpcomingTasks() {
    return [];
  }

  @override
  addCategory(String title, Color color){
    categories.add(TaskCategory(title: title, color: color));
    notifyListeners();
  }

  @override
  int getTaskCount(String categoryTitle) {
    return 0;
  }
  @override
  List<TaskDetails> getTasksByCategory(String category) {
    return [];
  }

  // FIX: Return a real stream instead of using `when()`
  final StreamController<List<TaskDetails>> _completedTasksController =
  StreamController<List<TaskDetails>>();

  @override
  Stream<List<TaskDetails>> getCompletedTasksStream() {
    return _completedTasksController.stream;
  }

  // Use this function in your test to set completed tasks
  void setCompletedTasks(List<TaskDetails> tasks) {
    _completedTasksController.add(tasks);
  }

  // Close the stream to avoid memory leaks
  void dispose() {
    _completedTasksController.close();
  }
}