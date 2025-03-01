import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import 'package:partners/widgets/task_item_card.dart';

class TaskListPage extends StatelessWidget {
  final String category;

  const TaskListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final categoryTasks = taskProvider.getTasksByCategory(category);

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
                      return TaskItemCard(taskId: task.id);
                    },
                  ),
          ),
        ));
  }
}
