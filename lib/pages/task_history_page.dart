import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../model/task_details.dart';
import '../widgets/task_item_card.dart'; // Assuming this exists

class TaskHistoryPage extends StatelessWidget {
  const TaskHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Task History"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<TaskDetails>>(
        stream: taskProvider.getCompletedTasksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No completed tasks found."));
          }

          final completedTasks = snapshot.data!;

          return ListView.builder(
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              return TaskItemCard(task: completedTasks[index]);
            },
          );
        },
      ),
    );
  }
}
