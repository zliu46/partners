import 'package:flutter/material.dart';
import 'package:partners/widgets/header.dart';
import 'package:partners/widgets/ongoing_task_section.dart';
import 'package:provider/provider.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:partners/widgets/task_categories_section.dart';
import 'package:partners/widgets/task_list_section.dart';

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
              Header(userName: 'Noah', userInitial: 'N'),
              // Task Categories Section
              TaskCategoriesSection(categories: categories),

              const SizedBox(height: 20.0),

              // Ongoing Tasks Section
              OngoingTaskSection(),

              const SizedBox(height: 20.0),

              // Upcoming Tasks Section
              // Expanded(
              //   child: TaskListSection(
              //     title: "UPCOMING TASKS",
              //     tasks: upcomingTasks,
              //     showSeeAll: true,
              //
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
