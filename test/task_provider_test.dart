import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import 'task_provider_test.mocks.dart';

@GenerateMocks([FirebaseFirestore])
void main() {
  late MockFirebaseFirestore mockFirebaseFirestore;
  late TaskProvider taskProvider;
  setUp((){
    mockFirebaseFirestore = MockFirebaseFirestore();
    taskProvider = TaskProvider()
      .._db = mockFirebaseFirestore;
  });
}