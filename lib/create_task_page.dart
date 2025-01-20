import 'package:flutter/material.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

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

  Future<void> _selectTime({required bool isStartTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'CREATE NEW TASK',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
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
                ),
                SizedBox(height: 20.0),
                _buildInputField(
                  label: 'Description',
                  hintText: 'Enter task description',
                  icon: Icons.description,
                  maxLines: 4,
                ),
                SizedBox(height: 20.0),
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
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.black),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: SwitchListTile(
                        title: Text('Get Alert for This Task'),
                        value: false,
                        onChanged: (value) {
                          // Handle switch logic
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle task creation logic
                      // You can use _selectedDate, _startTime, and _endTime here
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                      backgroundColor: Colors.black,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
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
        TextField(
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
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
