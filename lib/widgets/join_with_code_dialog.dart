import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';

class JoinWithCodeDialog extends StatefulWidget {
  const JoinWithCodeDialog({super.key});

  @override
  _JoinWithCodeDialogState createState() => _JoinWithCodeDialogState();
}

class _JoinWithCodeDialogState extends State<JoinWithCodeDialog> {
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return AlertDialog(
      title: const Text("Join With Code"),
      content: TextField(
        controller: codeController,
        decoration: const InputDecoration(labelText: "Partnership code"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (codeController.text.isNotEmpty) {
              try {
                // find partnership with code
                await taskProvider.joinPartnership(codeController.text);
                Navigator.pop(context);
                await taskProvider.fetchPartnerships();
                print('ERROR HERE ERROR HERE ERROR HERE');
                await taskProvider.setCurrentPartnership(0);
                Navigator.pushReplacementNamed(context, '/home');
              } catch (e){
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("join failed: ${e.toString()}")));
              }
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}

// 🔹 Function to Show the Dialog
void showJoinWithCodeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const JoinWithCodeDialog(),
  );
}
