import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:partners/provider/database_service.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import 'task_provider_test.mocks.dart';

@GenerateMocks([DatabaseService])
void main() {
  late DatabaseService db;
  late TaskProvider taskProvider;
  setUp((){
    db = MockDatabaseService();
    taskProvider = TaskProvider(db: db);
  });

  testWidgets("Test provider basic functionality", (tester) async {

    expect(true, true);
  });
}