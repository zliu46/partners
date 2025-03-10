import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/task_category_card.dart';

class TaskCategoriesPage extends StatelessWidget {
  const TaskCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final categories = taskProvider.categories;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Task Categories',
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
              const Text(
                'TASK CATEGORIES',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),

              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final taskCount = taskProvider.getTaskCount(category.title);
                    return TaskCategoryCard(taskCategory: category, taskCount: taskCount);
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button to Add Category
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddCategoryDialog(context);
        },
        backgroundColor: Colors.blue[100],
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
