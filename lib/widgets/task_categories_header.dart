import 'package:flutter/material.dart';
class TaskCategoriesHeader extends StatelessWidget {
  const TaskCategoriesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
