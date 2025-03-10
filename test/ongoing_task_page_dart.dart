import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partners/pages/ongoing_task_page.dart';
import 'package:partners/widgets/task_item_card.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:partners/model/task_details.dart';
import 'package:provider/provider.dart';
import 'mock_task_provider.dart';

void main() {
  late MockTaskProvider mockTaskProvider;
  late List<TaskDetails> mockOngoingTasks;

  setUp(() {
    mockTaskProvider = MockTaskProvider();
    mockOngoingTasks = [
      TaskDetails(
        id: "1",
        title: "Ongoing Task",
        category: "Work",
        description: "This is an ongoing task",
        createdBy: "User",
        endTime: DateTime.now(),
        isCompleted: false,
        assignedTo: "User",
        startTime: DateTime.now(),
      ),
    ];
  });

  Widget createTestWidget() {
    return ChangeNotifierProvider<TaskProvider>.value(
      value: mockTaskProvider,
      child: const MaterialApp(
        home: OngoingTaskPage(),
      ),
    );
  }

  testWidgets('Displays AppBar title correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.text('Ongoing Tasks'), findsOneWidget);
  });

  // testWidgets('Displays ongoing tasks when available', (WidgetTester tester) async {
  //
  //   await tester.pumpWidget(createTestWidget());
  //   await tester.pumpAndSettle();
  //
  //   expect(find.byType(TaskItemCard), findsOneWidget);
  //   //expect(find.text("Ongoing Task"), findsOneWidget);
  // });

  testWidgets('Displays "No ongoing tasks available" when no tasks exist', (WidgetTester tester) async {

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text("No ongoing tasks available"), findsOneWidget);
  });

  testWidgets('Back button works correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
  });
}
