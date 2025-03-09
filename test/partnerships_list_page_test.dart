import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:partners/model/partnership.dart';
import 'package:partners/pages/partnerships_list_page.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:provider/provider.dart';

import 'partnerships_list_page_test.mocks.dart';

@GenerateMocks([TaskProvider])
main() async {
  late MockTaskProvider mockTaskProvider = MockTaskProvider();
  when(mockTaskProvider.partnerships).thenAnswer((_) => [Partnership('test 1', '1'), Partnership('test 2', '2')]);
  when(mockTaskProvider.username).thenAnswer((_) => 'test');
  await mockTaskProvider.setCurrentPartnership(0);
  when(mockTaskProvider.currentPartnershipIndex).thenAnswer((_) => 0);
  when(mockTaskProvider.fetchPartnershipStream('1')).thenAnswer(
          (_) {
        final mockData = {
          'id': '1',
          'name': 'test 1',
          'users': [],
          'secret_code': '12345',
        };
        return Stream.value(mockData);
      });
  when(mockTaskProvider.fetchPartnershipStream('2')).thenAnswer(
          (_) {
        final mockData = {
          'id': '2',
          'name': 'test 2',
          'users': [],
          'secret_code': '12345',
        };
        return Stream.value(mockData);
      });

  testWidgets("Ensure PartnershipsListPage has all necessary sections", (tester) async {

    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider<TaskProvider>.value(
        value: mockTaskProvider,
        child: PartnershipsListPage()),
    )
    );
    expect(find.text("Create a Partnership"), findsOneWidget);
    expect(find.text("Join a Partnership"), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsNWidgets(2));
    expect(find.byType(Card), findsNWidgets(2));
  });

  testWidgets("Ensure selecting other partnership works properly", (tester) async {

    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider<TaskProvider>.value(
          value: mockTaskProvider,
          child: PartnershipsListPage()),
    )
    );
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNWidgets(2));
    final checkboxes = find.descendant(
      of: find.byType(ListTile),
      matching: find.byType(Checkbox),
    );
    when(mockTaskProvider.currentPartnershipIndex).thenAnswer((_) => 1);
    await tester.tap(checkboxes.at(1));
    await tester.pumpAndSettle();
    Checkbox secondCheckbox = tester.widget<Checkbox>(checkboxes.at(1));
    print(secondCheckbox);
    expect(secondCheckbox.value, true);
    Checkbox firstCheckbox = tester.widget<Checkbox>(checkboxes.at(0));
    expect(firstCheckbox.value, false);});
}