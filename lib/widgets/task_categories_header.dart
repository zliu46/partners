import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';

class TaskCategoriesHeader extends StatelessWidget {
  const TaskCategoriesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final hasMoreThanFourCategories = taskProvider.categories.length > 4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TASK CATEGORIES',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5, // Slight letter spacing for better readability
            ),
          ),
          if (hasMoreThanFourCategories) // Show only if there are more than 4 categories
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/taskCategories');
              },
              child: const Text('SEE ALL'),
            ),
        ],
      ),
    );
  }
}

