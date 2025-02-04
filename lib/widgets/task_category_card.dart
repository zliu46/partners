import 'package:flutter/material.dart';

import '../model/task_category.dart';
import '../screens/task_list_page.dart';
class TaskCategoryCard extends StatelessWidget {
  final TaskCategory taskCategory;
  final int taskCount;
  const TaskCategoryCard({required this.taskCategory, required this.taskCount, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskListPage(category: taskCategory.title),
          ),
        );
      },
      child: Container(
        height: 100.0,
        width: 150.0,
        decoration: BoxDecoration(
          color: taskCategory.color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Text(
            "${taskCategory.title}\n$taskCount TASKS",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
