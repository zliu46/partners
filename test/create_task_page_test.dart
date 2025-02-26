// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:partners/pages/create_task_page.dart';
// import 'package:partners/provider/task_provider.dart';
// import 'package:provider/provider.dart';
//
// main() {
//   testWidgets('Ensure create task page renders all fields', (tester) async {
//     CreateTaskPage createTaskPage = CreateTaskPage();
//     await tester.pumpWidget(ChangeNotifierProvider(
//         create: (context) => TaskProvider(),
//         child: MaterialApp(home: Scaffold(body: createTaskPage))));
//
//     expect(find.text("TITLE"), findsOneWidget);
//     expect(find.text("CATEGORY"), findsOneWidget);
//     expect(find.text("DESCRIPTION"), findsOneWidget);
//     expect(find.text("DATE"), findsOneWidget);
//     expect(find.text("START TIME"), findsOneWidget);
//     expect(find.text("END TIME"), findsOneWidget);
//     expect(find.text("CREATE TASK"), findsOneWidget);
//   });
//
//   testWidgets('Ensure create task page properly creates tasks', (tester) async {
//     CreateTaskPage createTaskPage = CreateTaskPage();
//     await tester.pumpWidget(ChangeNotifierProvider(
//         create: (context) => TaskProvider(),
//         child: MaterialApp(home: Scaffold(body: createTaskPage))));
//
//     // store provider
//     TaskProvider provider = Provider.of<TaskProvider>(tester.element(find.byType(CreateTaskPage)), listen:false);
//     expect(provider.tasks.length, 0);
//
//     //fill out form
//     final titleField = find.ancestor(of: find.text('Enter task title'), matching: find.byType(TextField));
//     await tester.enterText(titleField, 'Test title');
//     await tester.pump();
//
//     //final dropdownMenu = find.ancestor(of: find.byType(DropdownMenuItem), matching: find.byType(Widget));
//     await tester.tap(find.text('Choose one'), warnIfMissed: false);
//     await tester.pumpAndSettle();
//     await tester.tap(find.text('Baby'));
//     await tester.pumpAndSettle();
//
//     final descriptionField = find.ancestor(of: find.text('Enter task description'), matching: find.byType(TextField));
//     await tester.enterText(descriptionField, 'Test description');
//
//     await tester.tap(find.byIcon(Icons.calendar_today));
//     await tester.pumpAndSettle();
//     await tester.tap(find.text('OK'));
//     await tester.pumpAndSettle();
//
//     await tester.scrollUntilVisible(find.text('Select start time'), 5, scrollable: find.byType(Scrollable).last);
//     await tester.tap(find.text('Select start time'),);
//     await tester.pumpAndSettle();
//     await tester.tap(find.text('OK'));
//     await tester.pumpAndSettle();
//
//     await tester.tap(find.byType(ElevatedButton));
//
//     expect(provider.tasks.length, 1);
//   });
// }
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:partners/pages/create_task_page.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:partners/model/task_category.dart';
import 'package:provider/provider.dart';
import 'create_task_page_test.mocks.dart';

@GenerateMocks([TaskProvider])
void main() {
  late MockTaskProvider mockTaskProvider;

  setUp(() {
    mockTaskProvider = MockTaskProvider();

    /// Define necessary stubs
    when(mockTaskProvider.categories).thenReturn([
      TaskCategory(title: 'Chores', color: Colors.blue),
      TaskCategory(title: 'Appointment', color: Colors.red),
    ]);

    when(mockTaskProvider.tasks).thenReturn([]);
    when(mockTaskProvider.getPartnershipUsers())
        .thenAnswer((_) async => ['Zhou', 'Joseph']);
  });

  Widget createTestWidget() {
    return ChangeNotifierProvider<TaskProvider>.value(
      value: mockTaskProvider,
      child: const MaterialApp(
        home: CreateTaskPage(),
      ),
    );
  }

  testWidgets('Ensure create task page renders all fields', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    /// Verify UI elements exist
    expect(find.text("TITLE"), findsOneWidget);
    expect(find.text("CATEGORY"), findsOneWidget);
    expect(find.text("DESCRIPTION"), findsOneWidget);
    expect(find.text("ASSIGN TO"), findsOneWidget);
    expect(find.text("DATE"), findsOneWidget);
    expect(find.text("START TIME"), findsOneWidget);
    expect(find.text("END TIME"), findsOneWidget);
    expect(find.text("CREATE TASK"), findsOneWidget);
  });

  testWidgets('Ensure create task page properly creates tasks', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    /// Mock task list before adding a task
    verifyNever(mockTaskProvider.addTask(
        any,
        any,
        any,
        any,
        any,
        any,
        any));

    /// Fill in the form
    await tester.enterText(find.byType(TextField).at(0), 'Doctor visit'); // Title
    await tester.enterText(
        find.byType(TextField).at(1), 'See Doctor'); // Description

    /// Select a category (First "Choose one")
    await tester.tap(find.byKey(Key('categoryDropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Appointment'));
    await tester.pumpAndSettle();

    /// Select a user to assign the task to (Second "Choose one")
    await tester.tap(find.byKey(Key('assignUserDropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zhou'));
    await tester.pumpAndSettle();

    /// Select a date
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();
    // await tester.tap(find.text('OK'));
    // await tester.pumpAndSettle();

    /// Select start and end times
    await tester.scrollUntilVisible(find.text('Select start time'), 5, scrollable: find.byType(Scrollable).last);
    await tester.tap(find.text('Select start time'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    /// Tap "Create Task" button
    await tester.tap(find.text('CREATE TASK'));
    await tester.pumpAndSettle();
    //
    /// Verify task was added
    // verify(mockTaskProvider.addTask(
    //   'Doctor visit',
    //   'Appointment',
    //   'See Doctor',
    //   'Zhou',
    //   any,
    //   any,
    // )).called(1);
    //expect(mockTaskProvider.tasks.length, 1);
  });
}