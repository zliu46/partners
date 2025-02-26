import 'package:flutter/material.dart';
import '../model/task_details.dart';

class TaskDetailsPage extends StatelessWidget {
  final TaskDetails task;
  const TaskDetailsPage({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Provide default time if startTime or endTime is null
    final startTime = task.startTime ?? DateTime.now();
    final endTime = task.endTime ?? DateTime.now().add(const Duration(hours: 1));

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
          'Task Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Text(
                "Category: ${task.category}",
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.red),
                  const SizedBox(width: 5.0),
                  Text(
                    "${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text(
                "Task Description:",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Text(
                task.description,
                style: const TextStyle(fontSize: 16.0),
              ),
              if (task.assignedTo != '')
                const SizedBox(height: 20.0),
              if (task.assignedTo != '')
                const Text(
                  "Assigned To:",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              if (task.assignedTo != '')
                const SizedBox(height: 10.0),
              if (task.assignedTo != '')
                Text(
                  task.assignedTo,
                  style: const TextStyle(fontSize: 16.0),
                ),
              const SizedBox(height: 20.0),
              const Text(
                "Created By:",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Text(
                task.createdBy,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
