import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partners/model/task_details.dart';
import 'package:partners/pages/task_details_page.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:provider/provider.dart';

import 'mock_task_provider.dart';

void main() {
  late MockTaskProvider mockTaskProvider;

  group('Test task detail page widget', () {
    late TaskDetails mockTask;
    setUp((){
      mockTask = TaskDetails(
          id: '1',
          title: 'Wash baby bottles',
          category: 'Baby',
          description: 'Clean the baby bottles and put them in the serializer.',
          createdBy: 'Zhou',
          startTime: DateTime(2025, 2, 20, 10, 0),
          endTime: DateTime(2025, 2, 20, 10, 20),
          assignedTo: '',
          isCompleted: false
      );
    });
    testWidgets('Show correct task details on the screen', (tester) async{
      mockTaskProvider = MockTaskProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<TaskProvider>.value(
            value: mockTaskProvider,
            child: TaskDetailsPage(task: mockTask),
          ),
        ),
      );

      //Check title
      expect(find.text('Wash baby bottles'), findsOneWidget );

      //Check category
      expect(find.text('Category: Baby'), findsOneWidget );

      //Check task description
      expect(find.text('Clean the baby bottles and put them in the serializer.'), findsOneWidget);

      //Check created by user
      expect(find.text('Created By:'), findsOneWidget);
      expect(find.text('Zhou'), findsOneWidget);
      
      //Check date
      expect(find.text('10:00 - 10:20'), findsOneWidget);
    });
  });
}

