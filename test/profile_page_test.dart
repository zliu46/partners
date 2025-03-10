import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partners/pages/profile_page.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:provider/provider.dart';

import 'mock_task_provider.dart';


void main() {
  late MockTaskProvider mockTaskProvider;

  testWidgets('Ensure profile page has all sections', (tester) async {
    mockTaskProvider = MockTaskProvider();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskProvider>.value(
          value: mockTaskProvider,
          child: ProfilePage(),
        ),
      ),
    );

    // ensure all sections appear
    expect(find.text('PROFILE'), findsOneWidget);
    expect(find.text('EDIT PROFILE'), findsOneWidget);
    expect(find.text('PARTNERSHIPS'), findsOneWidget);
    expect(find.text('NOTIFICATIONS'), findsOneWidget);
    expect(find.text('HISTORY'), findsOneWidget);
    expect(find.text('HELP'), findsOneWidget);

  });
}