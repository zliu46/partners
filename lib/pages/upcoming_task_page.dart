import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../widgets/task_item_card.dart';

class UpcomingTaskPage extends StatelessWidget {
  const UpcomingTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final upcomingTasks = taskProvider.getUpcomingTasks();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Upcoming Tasks',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: upcomingTasks.isNotEmpty
              ? ListView.builder(
            itemCount: upcomingTasks.length,
            itemBuilder: (context, index) {
              final task = upcomingTasks[index];
              return TaskItemCard(taskId: task.id);
            },
          )
              : const Center(
            child: Text("No upcoming tasks available", style: TextStyle(color: Colors.grey)),
          ),
        ),
      ),
    );
  }
}
