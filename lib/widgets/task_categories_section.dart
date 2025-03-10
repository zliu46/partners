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
    final displayedCategories = categories.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TaskCategoriesHeader(),
        const SizedBox(height: 10.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayedCategories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return TaskCategoryCard(
              taskCategory: category,
              taskCount: taskProvider.getTaskCount(category.title),
            );
          },
        ),
      ],
    );
  }
}
