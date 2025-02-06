import 'package:flutter/material.dart';
import 'package:partners/widgets/task_categories_header.dart';
import 'package:partners/widgets/task_category_card.dart';
import 'package:provider/provider.dart';
import '../model/task_category.dart';
import '../provider/task_provider.dart';

class TaskCategoriesSection extends StatelessWidget {
  final List<TaskCategory> categories;
  const TaskCategoriesSection({required this.categories, super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TaskCategoriesHeader(),
        const SizedBox(height: 10.0),
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
