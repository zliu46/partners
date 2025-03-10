import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
        backgroundColor: Colors.blue[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '$category Tasks',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: categoryTasks.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'lib/assets/complete.json', // Ensure this file exists in assets folder
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  "No tasks available",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          )
              : ListView.builder(
            itemCount: categoryTasks.length,
            itemBuilder: (context, index) {
              final task = categoryTasks[index];
              return TaskItemCard(taskId: task.id);
            },
          ),
        ),
      ),
    );
  }
}
