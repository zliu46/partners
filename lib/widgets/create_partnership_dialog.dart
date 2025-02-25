import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';

class CreatePartnershipDialog extends StatefulWidget {
  const CreatePartnershipDialog({super.key});

  @override
  _CreatePartnershipDialogState createState() => _CreatePartnershipDialogState();
}

class _CreatePartnershipDialogState extends State<CreatePartnershipDialog> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return AlertDialog(
      title: const Text("Create partnership"),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(labelText: "Partnership name"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              taskProvider.createPartnership(nameController.text);
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          child: const Text("Create"),
        ),
      ],
    );
  }
}

// 🔹 Function to Show the Dialog
void showCreatePartnershipDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const CreatePartnershipDialog(),
  );
}
