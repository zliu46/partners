import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../model/task_details.dart';
import '../pages/task_details_page.dart';
import '../provider/task_provider.dart';

class TaskItemCard extends StatefulWidget {
  final String taskId;
  const TaskItemCard({required this.taskId, super.key});

  @override
  State<TaskItemCard> createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<TaskItemCard> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: true);
    final TaskDetails task = taskProvider.getTaskById(widget.taskId);

    final startTime = task.startTime ?? DateTime.now();
    final endTime = task.endTime ?? startTime.add(const Duration(hours: 1));

    return Slidable(
      key: ValueKey(widget.taskId),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              _deleteTask(context, taskProvider, widget.taskId);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailsPage(task: task),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: task.isCompleted ? Colors.grey[100] : Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 6,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Icon with Background Color
              CircleAvatar(
                backgroundColor: task.isCompleted ? Colors.grey : Colors.blue[100],
                child: const Icon(Icons.task, color: Colors.white),
              ),
              const SizedBox(width: 12), // Ensures proper spacing

              // Task Info Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: task.isCompleted ? Colors.grey[700] : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16.0, color: Colors.red),
                        const SizedBox(width: 5),
                        Text(
                          "${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} - "
                              "${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Checkbox & Navigation Arrow
              Checkbox(
                value: task.isCompleted,
                onChanged: (newValue) {
                  if (newValue != null) {
                    taskProvider.changeCompletion(task.id);
                  }
                },
              ),
              const Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteTask(BuildContext context, TaskProvider taskProvider, String taskId) {
    taskProvider.deleteTask(taskId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task deleted'), duration: Duration(seconds: 2)),
    );
  }
}
