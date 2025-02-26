import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partners/model/task_category.dart';

// Mock class (if needed for future tests)
class MockTaskCategory extends Mock implements TaskCategory {}

void main() {
  group('TaskCategory Tests', () {
    test('fromMap() should correctly convert Map to TaskCategory', () {
      // Arrange: Define input data
      final Map<String, dynamic> mockData = {
        'title': 'Chores',
        'color': Colors.blue, // Color stored as an integer
      };

      // Act: Convert to TaskCategory
      final taskCategory = TaskCategory.fromMap(mockData);

      // Assert: Verify the values
      expect(taskCategory.title, 'Chores');
      expect(taskCategory.color, Colors.blue);
    });

    test('toString() should return the category title', () {
      // Arrange
      final taskCategory = TaskCategory(title: 'Appointment', color: Colors.red);

      // Act & Assert
      expect(taskCategory.toString(), 'Appointment');
    });
  });
}
