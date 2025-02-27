
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partners/model/task_category.dart';
import 'package:partners/model/task_details.dart';
import 'package:partners/pages/home_page.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:partners/widgets/task_category_card.dart';
import 'package:provider/provider.dart';

import 'mock_task_provider.dart';



main(){
  late MockTaskProvider mockTaskProvider;

  setUp((){
    mockTaskProvider = MockTaskProvider();
  });

  testWidgets("Home Page displays all sections", (tester) async {
    // Initialize the mock provider before creating the widget
    mockTaskProvider = MockTaskProvider();


    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskProvider>.value(
          value: mockTaskProvider,
          child: HomePage(), // HomePage will now have access to the provider
        ),
      ),
    );

    // Wait for any async operations
    await tester.pumpAndSettle();

    // Run assertions
    expect(find.text("TASK CATEGORIES"), findsOneWidget);
    expect(find.text("ONGOING TASKS"), findsOneWidget);
    expect(find.text("UPCOMING TASKS"), findsOneWidget);
  });

  testWidgets("Displays all categories", (tester) async {
    mockTaskProvider = MockTaskProvider();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskProvider>.value(
          value: mockTaskProvider,
          child: HomePage(),
        ),
      ),
    );

    expect(find.byType(TaskCategoryCard), findsNWidgets(mockTaskProvider.categories.length));
  });

  testWidgets("Adding categories to provider reflects in home page", (tester) async {
    mockTaskProvider = MockTaskProvider();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskProvider>.value(
          value: mockTaskProvider,
          child: HomePage(),
        ),
      ),
    );

    expect(find.byType(TaskCategoryCard), findsNWidgets(mockTaskProvider.categories.length));
    mockTaskProvider.addCategory("test category 1", Color(0));
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskProvider>.value(
          value: mockTaskProvider,
          child: HomePage(),
        ),
      ),
    );
    expect(find.byType(TaskCategoryCard), findsNWidgets(mockTaskProvider.categories.length));
  });
}