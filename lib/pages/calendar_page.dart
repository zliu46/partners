import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
        backgroundColor: Colors.blue[100],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'CALENDAR',
          style: TextStyle(color: Colors.white),
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
          // Task List
          Expanded(
            child: tasksForSelectedDay.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'lib/assets/calendar.json', // Ensure this file exists in assets folder
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "No tasks for this day",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
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
