import 'package:flutter/material.dart';

import '../model/task_details.dart';
class TaskItemCard extends StatelessWidget {
  final TaskDetails task;
  const TaskItemCard({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _getTaskColor(task.startTime),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                  Text(_formatTaskTime(task.startTime), style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ],
          ),
          Text(
            _getTaskDuration(task.startTime),
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatTaskTime(DateTime startTime) {
    return "${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}";
  }

  String _getTaskDuration(DateTime startTime) {
    final now = DateTime.now();
    final duration = startTime.difference(now).inHours;
    if (duration <= 0) return "NOW";
    return "${duration}H";
  }

  Color _getTaskColor(DateTime startTime) {
    final now = DateTime.now();
    final diff = startTime.difference(now).inHours;
    if (diff <= 0) return Colors.amber[100]!;
    if (diff <= 2) return Colors.green[100]!;
    if (diff <= 4) return Colors.purple[100]!;
    return Colors.blue[100]!;
  }
}
