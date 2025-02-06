import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/task_category.dart';
import '../provider/task_provider.dart';
import '../widgets/task_category_card.dart';

class TaskCategoriesSection extends StatelessWidget {
  final List<TaskCategory> categories;
  const TaskCategoriesSection({required this.categories, super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Title & "SEE ALL" Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'TASK CATEGORIES',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/taskCategories');
              },
              child: const Text('SEE ALL'),
            ),
          ],
        ),
        const SizedBox(height: 10.0),

        // 🔹 Category List (Uses `Wrap` for Responsive Layout)
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: categories
              .map((category) => TaskCategoryCard(
            taskCategory: category,
            taskCount: taskProvider.getTaskCount(category.title),
          ))
              .toList(),
        ),
      ],
    );
  }
}
