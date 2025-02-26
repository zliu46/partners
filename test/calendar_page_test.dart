import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:partners/pages/calendar_page.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:partners/model/task_details.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_page_test.mocks.dart';

@GenerateMocks([TaskProvider])
void main() {
  late MockTaskProvider mockTaskProvider;

  setUp(() {
    mockTaskProvider = MockTaskProvider();
  });

  Widget createTestWidget() {
    return ChangeNotifierProvider<TaskProvider>.value(
      value: mockTaskProvider,
      child: const MaterialApp(
        home: CalendarPage(),
      ),
    );
  }

  testWidgets('Displays calendar and task list', (WidgetTester tester) async {
    DateTime today = DateTime.now();
    when(mockTaskProvider.getTasksForDate(any)).thenAnswer((invocation) {
      final DateTime requestedDate = invocation.positionalArguments.first;
      print("Mocked `getTasksForDate` called for date: $requestedDate");
      if (requestedDate.year == today.year &&
          requestedDate.month == today.month &&
          requestedDate.day == today.day  ) {
        return [
          TaskDetails(
            id: '1',
            title: 'Wash bottle',
            category: 'Chores',
            description: 'Discuss project details',
            createdBy: 'User',
            startTime: requestedDate,
            endTime: requestedDate.add(Duration(hours: 1)),
            isCompleted: false,
            assignedTo: 'Nobody',
          ),
        ];
      } else {
        return [];
      }
    });

    when(mockTaskProvider.getTaskById(any)).thenAnswer((invocation) {
      return TaskDetails(
        id: '2',
        title: 'Mocked Task',
        category: 'Chores',
        description: 'Mocked Task Description',
        createdBy: 'User',
        startTime: today,
        endTime: today.add(Duration(hours: 1)),
        isCompleted: false,
        assignedTo: 'Team',
      );
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();
    // Verify the calendar UI
    expect(find.text('CALENDAR'), findsOneWidget);
    expect(find.byType(TableCalendar), findsOneWidget);
    // Verify if the mocked task appears
    expect(find.text('Mocked Task'), findsOneWidget);
  });
}

