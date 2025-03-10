import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partners/widgets/add_category_dialog.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'mock_task_provider.dart'; // Import generated mock

void main() {
  late MockTaskProvider mockTaskProvider;

  setUp(() {
    mockTaskProvider = MockTaskProvider();
  });

  Widget createTestWidget() {
    return ChangeNotifierProvider<TaskProvider>.value(
      value: mockTaskProvider,
      child: const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Test UI')), // Placeholder UI
        ),
      ),
    );
  }

  testWidgets('Displays Add Category Dialog', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    showAddCategoryDialog(tester.element(find.text('Test UI')));

    await tester.pumpAndSettle();

    expect(find.text('Add New Category'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Typing updates the text field', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    showAddCategoryDialog(tester.element(find.text('Test UI')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Work');
    expect(find.text('Work'), findsOneWidget);
  });

  testWidgets('Clicking Cancel closes the dialog', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    showAddCategoryDialog(tester.element(find.text('Test UI')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Add New Category'), findsNothing);
  });

  testWidgets('Clicking Add calls addCategory with entered text', (WidgetTester tester) async {
    when(mockTaskProvider.addCategory('', Colors.blue)).thenReturn(null);

    await tester.pumpWidget(createTestWidget());
    showAddCategoryDialog(tester.element(find.text('Test UI')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Work');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    verify(mockTaskProvider.addCategory('Work', Colors.blue)).called(1);
  });

  testWidgets('Clicking Add does not call addCategory if text is empty', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    showAddCategoryDialog(tester.element(find.text('Test UI')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    verifyNever(mockTaskProvider.addCategory('', Colors.blue));
  });
}
