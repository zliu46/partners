import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../widgets/task_item_card.dart';
import '../pages/ongoing_task_page.dart';

class OngoingTaskSection extends StatelessWidget {
  const OngoingTaskSection({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final ongoingTasks = taskProvider.getOngoingTasks(); // Fetch only ongoing tasks
    final limitedTasks = ongoingTasks.take(2).toList(); // Show only 2 initially

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ONGOING TASKS',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            if (ongoingTasks.length > 0) // Show "SEE ALL" only if more than 0 tasks
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OngoingTaskPage(),
                    ),
                  );
                },
                child: const Text("SEE ALL"),
              ),
          ],
        ),
        const SizedBox(height: 10.0),

        ongoingTasks.isNotEmpty
            ? Column(children: limitedTasks.map((task) => TaskItemCard(taskId: task.id)).toList())
            : const Text("No ongoing tasks", style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
