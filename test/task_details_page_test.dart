import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partners/model/task_details.dart';
import 'package:partners/pages/task_details_page.dart';

void main() {
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
      await tester.pumpWidget(
        MaterialApp(
          home:TaskDetailsPage(task: mockTask),
        )
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
    
    testWidgets('Test the back button to navigate back to previous page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TaskDetailsPage(task: mockTask),
                      ),
                    );
                  },
                  child: Text('See Task Details'),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap the button to navigate to TaskDetailsPage
      await tester.tap(find.text('See Task Details'));
      await tester.pumpAndSettle(); // Wait for navigation to complete

      // Verify that TaskDetailsPage is displayed
      expect(find.byType(TaskDetailsPage), findsOneWidget);

      // Tap the back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle(); // Wait for navigation to complete

      // Verify that TaskDetailsPage is removed and previous screen is shown
      expect(find.byType(TaskDetailsPage), findsNothing);
      expect(find.text('See Task Details'), findsOneWidget); // Previous page still exists
    });
  });
}

