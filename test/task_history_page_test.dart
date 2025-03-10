import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partners/pages/task_history_page.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:partners/model/task_details.dart';
import 'package:provider/provider.dart';
import 'mock_task_provider.dart';

void main() {
  late MockTaskProvider mockTaskProvider;
  late List<TaskDetails> mockTasks;

  setUp(() {
    mockTaskProvider = MockTaskProvider();
    mockTasks = [
      TaskDetails(
        id: "1",
        title: 'Clean',
        category: "Work",
        description: "This is a test task",
        createdBy: "User",
        endTime: DateTime.now(),
        isCompleted: true,
        assignedTo: "User",
        startTime: DateTime.now(),
      ),

      TaskDetails(
        id: "2",
        title: 'new task',
        category: "Work",
        description: "This is a test task",
        createdBy: "User",
        endTime: DateTime.now(),
        isCompleted: true,
        assignedTo: "User",
        startTime: DateTime.now(),
      )
    ];
  });

  Widget createTestWidget() {
    return ChangeNotifierProvider<TaskProvider>.value(
      value: mockTaskProvider,
      child: const MaterialApp(
        home: TaskHistoryPage(),
      ),
    );
  }

  testWidgets('Displays "Task History" in AppBar', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.text("Task History"), findsOneWidget);
  });

  testWidgets('Displays completed tasks when available',
          (WidgetTester tester) async {

        mockTaskProvider.setCompletedTasks(mockTasks);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Clean'), findsOneWidget);
        expect(find.text('new task'), findsOneWidget);
      });

  testWidgets('Displays "No completed tasks" when history is empty',
          (WidgetTester tester) async {

        mockTaskProvider.setCompletedTasks([]);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text("No completed tasks found."), findsOneWidget);
      });

  tearDown(() {
    mockTaskProvider.dispose();
  });
}
