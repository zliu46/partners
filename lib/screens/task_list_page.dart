import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../model/task_details.dart';

class TaskListPage extends StatelessWidget {
  final String category;

  const TaskListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final categoryTasks = taskProvider.getTasksByCategory('Baby');

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
    title: Text(
    '$category Tasks',
    style: const TextStyle(color: Colors.black),
    ),
    centerTitle: true,
    ),
    body: SafeArea(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: categoryTasks.isEmpty
    ? const Center(child: Text("No tasks available"))
        : ListView.builder(
    itemCount: categoryTasks.length,
    itemBuilder: (context, index) {
    final task = categoryTasks[index];
    return _TaskItemCard(task: task);
    },
    ),
    ),
    ));
  }
}

// 🔹 Task Card Widget
class _TaskItemCard extends StatelessWidget {
  final TaskDetails task;
  const _TaskItemCard({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.amber[100], // Customize based on category
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title.toUpperCase(),
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16.0, color: Colors.red),
              const SizedBox(width: 5.0),
              Text(
                "${task.startTime.hour}:${task.startTime.minute.toString().padLeft(2, '0')}",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
