import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partners/pages/upcoming_task_page.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:partners/widgets/task_item_card.dart';
import 'package:partners/model/task_details.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'mock_task_provider.dart';

void main() {
  late MockTaskProvider mockTaskProvider;
  late List<TaskDetails> mockUpcomingTasks;

  setUp(() {
    mockTaskProvider = MockTaskProvider();
    mockUpcomingTasks = [
      TaskDetails(
        id: "1",
        title: "Test Upcoming Task",
        category: "Work",
        description: "This is a test upcoming task",
        createdBy: "User",
        endTime: DateTime.now().add(Duration(days: 1)), // Future task
        isCompleted: false,
        assignedTo: "User",
        startTime: DateTime.now().add(Duration(days: 1)),
      ),
    ];

  });

  Widget createTestWidget() {
    return ChangeNotifierProvider<TaskProvider>.value(
      value: mockTaskProvider,
      child: const MaterialApp(
        home: UpcomingTaskPage(),
      ),
    );
  }

  testWidgets('Displays upcoming tasks when available', (WidgetTester tester) async {
    when(mockTaskProvider.getUpcomingTasks()).thenReturn(mockUpcomingTasks);
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle(); // Ensures UI updates

    expect(find.byType(TaskItemCard), findsOneWidget);
    expect(find.text("Test Upcoming Task"), findsOneWidget);
  });

  testWidgets('Displays "No upcoming tasks available" when no tasks exist', (WidgetTester tester) async {

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text("No upcoming tasks available"), findsOneWidget);
  });
}
