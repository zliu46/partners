import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import 'package:partners/widgets/task_tile.dart';

class BabyTaskPage extends StatelessWidget {
  const BabyTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final babyTasks = taskProvider.getTasksByCategory('baby');

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
          'TASKS LIST',
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
              Expanded(
                child: ListView.builder(
                  itemCount: babyTasks.length,
                  itemBuilder: (context, index) {
                    final task = babyTasks[index];
                    return TaskTile(task: task);
                  },
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/createTask');
                },
                backgroundColor: Colors.amber[100],
                child: const Icon(Icons.add, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
