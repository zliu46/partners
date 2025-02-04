import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../widgets/task_item_card.dart';

class OngoingTaskPage extends StatelessWidget {
  const OngoingTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final ongoingTasks = taskProvider.getOngoingTasks(); //

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
          'Ongoing Tasks',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ongoingTasks.isNotEmpty
              ? ListView.builder(
            itemCount: ongoingTasks.length,
            itemBuilder: (context, index) {
              final task = ongoingTasks[index];
              return TaskItemCard(task: task);
            },
          )
              : const Center(
            child: Text("No ongoing tasks available", style: TextStyle(color: Colors.grey)),
          ),
        ),
      ),
    );
  }
}
