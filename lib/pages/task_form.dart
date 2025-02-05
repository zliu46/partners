import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:partners/model/task_details.dart';

import 'package:partners/provider/task_provider.dart';
import 'package:provider/provider.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController =
      TextEditingController(); //maybe switch to dropdown menu
  final _descriptionController = TextEditingController();


  _onSave() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.addTask(
      _titleController.text,
      _categoryController.text,
      _descriptionController.text,
      "Noah",
      DateTime.now()
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("New Task"),
      ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  validator: (input) {
                    if (input == null || input.isEmpty) {
                      return 'Title cannot be empty.';
                    }
                    return null;
                  }),
              TextFormField(
                  //maybe switch to dropdown menu
                  decoration: const InputDecoration(labelText: 'Category'),
                  controller: _categoryController,
                  validator: (input) {
                    if (input == null || input.isEmpty) {
                      return 'Category cannot be empty.';
                    }
                    return null;
                  }),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  controller: _descriptionController,
                  validator: (input) {
                    if (input == null || input.isEmpty) {
                      return 'Description cannot be empty.';
                    }
                    return null;
                  }),
              InputDatePickerFormField(
                  firstDate: DateTime(0),
                  lastDate: DateTime.now().add(Duration(days: 365 * 100))),
              CupertinoButton(
                onPressed: _onSave,
                child: Text("Save"),
              )
            ])));
  }
}
