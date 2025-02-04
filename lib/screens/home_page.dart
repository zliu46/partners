import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../model/task_category.dart';
import '../model/task_details.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final categories = taskProvider.categories;
    final ongoingTasks = taskProvider.ongoingTasks;
    final upcomingTasks = taskProvider.upcomingTasks;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const _Header(),

              const SizedBox(height: 20.0),

              // Task Categories Section
              _TaskCategoriesSection(categories: categories),

              const SizedBox(height: 20.0),

              // Ongoing Tasks Section
              _TaskListSection(title: "ONGOING TASKS", tasks: ongoingTasks),

              const SizedBox(height: 20.0),

              // Upcoming Tasks Section
              Expanded(
                child: _TaskListSection(
                  title: "UPCOMING TASKS",
                  tasks: upcomingTasks,
                  showSeeAll: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
