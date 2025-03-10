import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:partners/provider/task_provider.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _category;
  String? _assignedTo;
  bool _enableNotification = false; // Default: No Notification

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Future<void> _selectTime({required bool isStartTime}) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       if (isStartTime) {
  //         _startTime = picked;
  //       } else {
  //         _endTime = picked;
  //       }
  //     });
  //   }
  // }
  Future<void> _selectTime({required bool isStartTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final selectedDate = _selectedDate ?? now; // Use selected date if available, else today
      final selectedDateTime = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, picked.hour, picked.minute,
      );

      // Ensure selected time is in the future
      if (selectedDateTime.isBefore(now)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select a future time")),
        );
        return;
      }

      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          if (_startTime == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please select a start time first")),
            );
            return;
          }

          // Convert TimeOfDay to DateTime for comparison
          final startDateTime = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day, _startTime!.hour, _startTime!.minute,
          );

          if (selectedDateTime.isBefore(startDateTime)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("End time must be after start time")),
            );
            return;
          }

          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Create New Task',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task Details',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                _buildInputField(
                  label: 'Title',
                  hintText: 'Enter task title',
                  icon: Icons.title,
                  controller: _titleController,
                ),
                SizedBox(height: 10.0),
                // category
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _inputLabel("CATEGORY"),
                  SizedBox(height: 5.0),
                ]),
                _categoryPicker(taskProvider),
                SizedBox(height: 20.0),
                _buildInputField(
                  label: 'Description',
                  hintText: 'Enter task description',
                  icon: Icons.description,
                  maxLines: 4,
                  controller: _descriptionController,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _inputLabel('ASSIGN TO'),
                  SizedBox(height: 5.0),
                ]),
                _assignToPicker(taskProvider),
                SizedBox(height: 20.0),
                ..._buildScheduleSection(),
                SizedBox(height: 20.0),
                _notificationBar(),
                SizedBox(height: 20.0),
                _buildCreateTaskButton(taskProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputLabel(String text){
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _categoryPicker(TaskProvider provider) {
    List<String> categories =
        provider.categories.map((category) => category.title).toList();
    return DropdownButtonFormField(
      key: Key('categoryDropdown'),
      value: _category,
      hint: Text('Choose one'),
      isExpanded: true,
      onChanged: (value) {
        setState(() {
          _category = value;
        });
      },
      items: categories.map((category) {
        return DropdownMenuItem(value: category, child: Text(category));
      }).toList(),
    );
  }

  Widget _assignToPicker(TaskProvider provider) {
    return FutureBuilder<List<String>>(
      future: provider.getPartnershipUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No users available');
        }

        final users = snapshot.data!;

        return DropdownButtonFormField<String>(
          key: Key('assignUserDropdown'),
          value: _assignedTo,
          hint: const Text('Choose one'),
          isExpanded: true,
          onChanged: (value) {
            setState(() {
              _assignedTo = value;
            });
          },
          items: users.map((user) {
            return DropdownMenuItem(value: user, child: Text(user));
          }).toList(),
        );
      },
    );
  }

  List<Widget> _buildScheduleSection() {
    return [
      Text(
        'Schedule',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10.0),
      GestureDetector(
        onTap: _selectDate,
        child: _buildDateTimeField(
          label: 'Date',
          value: _selectedDate != null
              ? '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'
              : 'Select date',
          icon: Icons.calendar_today,
        ),
      ),
      SizedBox(height: 20.0),
      Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _selectTime(isStartTime: true),
              child: _buildDateTimeField(
                label: 'Start Time',
                value: _startTime != null
                    ? _startTime!.format(context)
                    : 'Select start time',
                icon: Icons.access_time,
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectTime(isStartTime: false),
              child: _buildDateTimeField(
                label: 'End Time',
                value: _endTime != null
                    ? _endTime!.format(context)
                    : 'Select end time',
                icon: Icons.access_time,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _inputLabel(label.toUpperCase()),
        SizedBox(height: 5.0),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.black),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _notificationBar() {
    return Row(
      children: [
        Icon(Icons.notifications, color: Colors.black),
        SizedBox(width: 10.0),
        Expanded(
          child: SwitchListTile(
            activeTrackColor: Colors.blue[100],
            title: Text('Get Alert for This Task'),
            value: _enableNotification, // Bind to state variable
            onChanged: (bool value) {
              setState(() {
                _enableNotification = value; // Update state properly
              });
              print("Notification Toggle: $_enableNotification"); // Debugging
            },
          ),
        ),
      ],
    );
  }


  Widget _buildCreateTaskButton(TaskProvider taskProvider) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Ensure required fields are filled
          if (_titleController.text.isEmpty ||
              _category == null ||
              _selectedDate == null ||
              _startTime == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please fill in all required fields')),
            );
            return;
          }
          taskProvider.addTask(
            _titleController.text,
            _category!,
            _descriptionController.text,
            taskProvider.firstName,
            DateTime(_selectedDate!.year, _selectedDate!.month,
                _selectedDate!.day, _startTime!.hour, _startTime!.minute),
            _assignedTo ?? '',
            _enableNotification,
            _endTime != null
                ? DateTime(_selectedDate!.year, _selectedDate!.month,
                    _selectedDate!.day, _endTime!.hour, _endTime!.minute)
                : null,
          );

          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Task added successfully!')),
          );
          Navigator.pop(context);
          // Handle task creation logic
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
          backgroundColor: Colors.blue[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          'CREATE TASK',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
