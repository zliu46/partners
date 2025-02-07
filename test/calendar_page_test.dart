import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partners/pages/calendar_page.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:partners/widgets/task_item_card.dart';
import 'package:provider/provider.dart';

List<String> MONTHS = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

main() {
  testWidgets("Test CalendarPage opens to today's date", (tester) async {
    DateTime today = DateTime.now();
    String month = MONTHS[today.month - 1];
    String day = today.day.toString();
    String year = today.year.toString();

    CalendarPage calendar = CalendarPage();
    await tester.pumpWidget(ChangeNotifierProvider(
        create: (context) => TaskProvider(),
        child: MaterialApp(home: Scaffold(body: calendar))));

    expect(find.text("$month $year"), findsOneWidget);
    expect(find.text(day), findsOneWidget);
  });

  testWidgets(
      "Test CalendarPage displays correct number of tasks before and after creating tasks",
      (tester) async {
    CalendarPage calendar = CalendarPage();
    await tester.pumpWidget(ChangeNotifierProvider(
        create: (context) => TaskProvider(),
        child: MaterialApp(home: Scaffold(body: calendar))));

    TaskProvider provider = Provider.of<TaskProvider>(
        tester.element(find.byType(CalendarPage)),
        listen: false);

    child:
    MaterialApp(home: Scaffold(body: calendar));
    // first make sure we have 0 tasks
    expect(provider.tasks.length, 0);
    expect(find.byType(TaskItemCard), findsNothing);

    // add task for today
    provider.addTask('test', 'test', 'test', 'me', DateTime.now());
    await tester.pump();

    // assert that we now have 1 task displayed
    expect(find.byType(TaskItemCard), findsOneWidget);

    // add another task for today
    provider.addTask('test', 'test', 'test', 'me', DateTime.now());
    await tester.pump();
    // assert that we now have 2 task displayed
    expect(find.byType(TaskItemCard), findsNWidgets(2));
  });
}
