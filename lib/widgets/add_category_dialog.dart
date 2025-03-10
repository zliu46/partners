import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return AlertDialog(
      title: const Text("Add New Category"),
      content: TextField(
        controller: categoryController,
        decoration: const InputDecoration(labelText: "Category Name"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (categoryController.text.isNotEmpty) {
              taskProvider.addCategory(categoryController.text, Colors.purple[100]!);
              Navigator.pop(context);
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}

//  Function to Show the Dialog
void showAddCategoryDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const AddCategoryDialog(),
  );
}


