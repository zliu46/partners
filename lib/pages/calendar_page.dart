import 'package:flutter/material.dart';
import 'package:partners/model/task_details.dart';
import 'package:partners/pages/home_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:partners/provider/task_provider.dart';

import '../widgets/task_item_card.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    List<TaskDetails> tasksForSelectedDay =
        taskProvider.getTasksForDate(_selectedDay ?? _focusedDay);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage())),
        ),
        title: Text(
          'CALENDAR',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Calendar Widget
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.week,
            calendarStyle: CalendarStyle(
              selectedDecoration:
                  BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              todayDecoration: BoxDecoration(
                  color: Colors.grey[300], shape: BoxShape.circle),
            ),
            headerStyle:
                HeaderStyle(formatButtonVisible: false, titleCentered: true),
          ),
          const SizedBox(height: 10),
          // Task List
          Expanded(
            child: tasksForSelectedDay.isEmpty
                ? Center(child: Text("No tasks for this day"))
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: tasksForSelectedDay.length,
                        itemBuilder: (context, index) {
                          final task = tasksForSelectedDay[index];
                          return TaskItemCard(taskId: task.id);
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
