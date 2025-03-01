import 'package:flutter/material.dart';
import 'package:partners/pages/task_details_page.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../model/task_details.dart';

class TaskHistoryPage extends StatelessWidget {
  const TaskHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task History"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<TaskDetails>>(
        stream: taskProvider.getCompletedTasksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No completed tasks found."));
          }

          final completedTasks = snapshot.data!;

          return ListView.builder(
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              final task = completedTasks[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    "Completed on: ${task.endTime != null ? "${task.endTime.toLocal()}" : "Unknown"}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsPage(task: task),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
