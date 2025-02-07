import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partners/pages/create_task_page.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:provider/provider.dart';

main() {
  testWidgets('Ensure create task page renders all fields', (tester) async {
    CreateTaskPage createTaskPage = CreateTaskPage();
    await tester.pumpWidget(ChangeNotifierProvider(
        create: (context) => TaskProvider(),
        child: MaterialApp(home: Scaffold(body: createTaskPage))));

    expect(find.text("TITLE"), findsOneWidget);
    expect(find.text("CATEGORY"), findsOneWidget);
    expect(find.text("DESCRIPTION"), findsOneWidget);
    expect(find.text("DATE"), findsOneWidget);
    expect(find.text("START TIME"), findsOneWidget);
    expect(find.text("END TIME"), findsOneWidget);
    expect(find.text("CREATE TASK"), findsOneWidget);
  });

  testWidgets('Ensure create task page properly creates tasks', (tester) async {
    CreateTaskPage createTaskPage = CreateTaskPage();
    await tester.pumpWidget(ChangeNotifierProvider(
        create: (context) => TaskProvider(),
        child: MaterialApp(home: Scaffold(body: createTaskPage))));

    // store provider
    TaskProvider provider = Provider.of<TaskProvider>(tester.element(find.byType(CreateTaskPage)), listen:false);
    expect(provider.tasks.length, 0);

    //fill out form
    final titleField = find.ancestor(of: find.text('Enter task title'), matching: find.byType(TextField));
    await tester.enterText(titleField, 'Test title');
    await tester.pump();

    //final dropdownMenu = find.ancestor(of: find.byType(DropdownMenuItem), matching: find.byType(Widget));
    await tester.tap(find.text('Choose one'), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Baby'));
    await tester.pumpAndSettle();

    final descriptionField = find.ancestor(of: find.text('Enter task description'), matching: find.byType(TextField));
    await tester.enterText(descriptionField, 'Test description');

    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Select start time'), 5, scrollable: find.byType(Scrollable).last);
    await tester.tap(find.text('Select start time'),);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));

    expect(provider.tasks.length, 1);
  });
}