import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partners/model/task_category.dart';

void main() {
  group ('Test TaskCategory class',() {
    test('Should create TaskCategory successfully', () {
      final taskCategory = TaskCategory(title: 'Baby care', color: Colors.red);
      expect(taskCategory.title, 'Baby care');
      expect(taskCategory.color, Colors.red);
    }
    );

    test('Test toString method',() {
      final taskCategory = TaskCategory(title: 'Baby care', color: Colors.red);
      expect(taskCategory.toString(), 'Baby care');
    }
    );

  });
}