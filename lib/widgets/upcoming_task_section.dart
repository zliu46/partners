import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../widgets/task_item_card.dart';
import '../pages/upcoming_task_page.dart';

class UpcomingTaskSection extends StatelessWidget {
  const UpcomingTaskSection({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final upcomingTasks = taskProvider.getUpcomingTasks(); // Get upcoming tasks
    final limitedTasks = upcomingTasks.take(2).toList(); //  Show only 2 tasks initially

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Title & "SEE ALL" Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'UPCOMING TASKS',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            if (upcomingTasks.isNotEmpty) // Show "SEE ALL" if more than 2 tasks exist
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpcomingTaskPage(),
                    ),
                  );
                },
                child: const Text("SEE ALL"),
              ),
          ],
        ),
        const SizedBox(height: 10.0),

        // 🔹 Display Upcoming Tasks
        upcomingTasks.isNotEmpty
            ? Column(children: limitedTasks.map((task) => TaskItemCard(taskId: task.id)).toList())
            : const Text("No upcoming tasks", style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
