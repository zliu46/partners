import 'package:flutter_test/flutter_test.dart';
import 'package:partners/model/task_details.dart';

void main() {
  group ('Test TaskDetails class', () {
    test('Create a TaskDetails instance successfully', ()
    {
      final task = TaskDetails(
        id: '1',
        title: 'Wash baby bottles',
        category: 'Baby',
        description: 'Clean the baby bottles and put them in the serializer',
        createdBy: 'Zhou',
        startTime: DateTime(2025, 2, 20, 10, 0),
        endTime: DateTime(2025, 2, 20, 10, 20),
        assignedTo: '',
        isCompleted: false
      );
      expect(task.id, '1');
      expect(task.title, 'Wash baby bottles');
      expect(task.category, 'Baby');
      expect(task.description, 'Clean the baby bottles and put them in the serializer');
      expect(task.createdBy, 'Zhou');
      expect(task.startTime, DateTime(2025, 2, 20, 10, 0));
      expect(task.endTime, DateTime(2025, 2, 20, 10, 20));
      expect(task.isCompleted, false);
    }
    );

    test('Create a TaskDetails instance using fromMap factory', ()
    {
      final task = TaskDetails.fromMap({
        'id': '1',
        'title': 'Wash baby bottles',
        'category': 'Baby',
        'description': 'Clean the baby bottles and put them in the serializer',
        'createdBy': 'Zhou',
        'startTime': DateTime(2025, 2, 20, 10, 0),
        'endTime': DateTime(2025, 2, 20, 10, 20),
        'assignedTo': '',
        'isCompleted': false
      });
      expect(task.id, '1');
      expect(task.title, 'Wash baby bottles');
      expect(task.category, 'Baby');
      expect(task.description, 'Clean the baby bottles and put them in the serializer');
      expect(task.createdBy, 'Zhou');
      expect(task.startTime, DateTime(2025, 2, 20, 10, 0));
      expect(task.endTime, DateTime(2025, 2, 20, 10, 20));
      expect(task.isCompleted, false);
    }
    );

    test("Ensure Taskdetail's .changeCompletion() function works", ()
    {
      final task = TaskDetails(
          id: '1',
          title: 'Wash baby bottles',
          category: 'Baby',
          description: 'Clean the baby bottles and put them in the serializer',
          createdBy: 'Zhou',
          startTime: DateTime(2025, 2, 20, 10, 0),
          endTime: DateTime(2025, 2, 20, 10, 20),
          assignedTo: '',
          isCompleted: false
      );

      expect(task.isCompleted, false);

      task.changeCompletion();
      expect(task.isCompleted, true);

    }
    );
  });
}