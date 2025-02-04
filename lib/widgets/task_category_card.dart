import 'package:flutter/material.dart';

import '../model/task_category.dart';
import '../pages/task_list_page.dart';
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
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: taskCategory.color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              taskCategory.title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "$taskCount TASKS",
              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
