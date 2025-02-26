import 'dart:ui';

import 'package:mockito/mockito.dart';
import 'package:partners/model/task_category.dart';
import 'package:partners/model/task_details.dart';
import 'package:partners/provider/task_provider.dart';

class MockTaskProvider extends Mock implements TaskProvider {
  @override
  List<TaskCategory> categories = [];

  @override
  List<TaskDetails> ongoingTasks = [];

  @override
  List<TaskDetails> upcomingTasks = [];

  @override
  String firstName = '';

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
}