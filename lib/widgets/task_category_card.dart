import 'package:flutter/material.dart';
import '../model/task_category.dart';
import '../pages/task_list_page.dart';

class TaskCategoryCard extends StatelessWidget {
  final TaskCategory taskCategory;
  final int taskCount;

  const TaskCategoryCard({required this.taskCategory, required this.taskCount, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        tileColor: taskCategory.color.withValues(alpha: 0.2), // Softer background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),),
        leading: CircleAvatar(
          backgroundColor: taskCategory.color.withValues(alpha: 0.8), // Use category color
          child: Icon(Icons.category, color: Colors.white),
        ),
        title: Text(
          taskCategory.title,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // Darker for contrast
          ),
        ),
        subtitle: Text(
          "$taskCount TASKS",
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskListPage(category: taskCategory.title),
            ),
          );
        },
      ),
    );
  }
}

