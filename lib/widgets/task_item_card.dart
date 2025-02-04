import 'package:flutter/material.dart';
import '../model/task_details.dart';
import '../pages/task_details_page.dart';

class TaskItemCard extends StatelessWidget {
  final TaskDetails task;
  const TaskItemCard({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Use default time if startTime or endTime is null
    final startTime = task.startTime ?? DateTime.now();
    final endTime = task.endTime ?? DateTime.now().add(const Duration(hours: 1));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsPage(task: task),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16.0, color: Colors.red),
                    const SizedBox(width: 5.0),
                    Text(
                      "${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
