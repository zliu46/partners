import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partners/pages/task_list_page.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:provider/provider.dart';
import 'mock_task_provider.dart';

void main() {
  late MockTaskProvider mockTaskProvider;

  setUp(() {
    mockTaskProvider = MockTaskProvider();
  });

  Widget createTestWidget(String category) {
    return ChangeNotifierProvider<TaskProvider>.value(
      value: mockTaskProvider,
      child: MaterialApp(
        home: TaskListPage(category: category),
      ),
    );
  }

  testWidgets('Displays category name in AppBar', (WidgetTester tester) async {

    await tester.pumpWidget(createTestWidget("Work"));
    expect(find.text("Work Tasks"), findsOneWidget);
  });

  testWidgets('Displays "No tasks available" when no tasks exist',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget("Work"));
        await tester.pumpAndSettle();

        expect(find.text("No tasks available"), findsOneWidget);
      });

}