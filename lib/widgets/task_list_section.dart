import 'package:flutter/material.dart';
import 'package:partners/widgets/task_item_card.dart';

import '../model/task_details.dart';
class TaskListSection extends StatelessWidget {
  final String title;
  final List<TaskDetails> tasks;
  final bool showSeeAll;

  const TaskListSection({
    required this.title,
    required this.tasks,
    this.showSeeAll = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            if (showSeeAll)
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/upcomingTask');
                },
                child: const Text("SEE ALL"),
              ),
          ],
        ),
        const SizedBox(height: 10.0),
        tasks.isNotEmpty
            ? Column(children: tasks.map((task) => TaskItemCard(taskId: task.id)).toList())
            : const Text("No tasks available", style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
