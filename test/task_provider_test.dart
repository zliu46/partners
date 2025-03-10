import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:partners/model/task_details.dart';
import 'package:partners/provider/auth_service.dart';
import 'package:partners/provider/database_service.dart';
import 'package:partners/provider/noti_service.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import 'task_provider_test.mocks.dart';

@GenerateMocks([DatabaseService, AuthService, NotiService])
void main() {
  late MockDatabaseService db;
  late MockAuthService auth;
  late MockNotiService noti;
  late TaskProvider taskProvider;

  setUp(() async {
    db = MockDatabaseService();
    auth = MockAuthService();
    noti = MockNotiService();
    taskProvider = TaskProvider(db: db, auth: auth, noti: noti);
    when(db.getPartnerships(any)).thenAnswer((_) async => ["p1"]);
    when(db.getPartnershipWithId("p1"))
        .thenAnswer((_) async => "Test Partnership");
    when(db.createPartnership(any)).thenAnswer((_) async => "dummyID");
    when(db.joinPartnership(any, any)).thenAnswer((_) async => '');
    taskProvider.setUsername("test user");

    await taskProvider.fetchPartnerships();
    taskProvider.setFirstName("test");
    taskProvider.setCurrentPartnership(0);
  });

  test('TaskProvider should initialize with empty lists', () {
    expect(taskProvider.tasks, isEmpty);
    expect(taskProvider.categories, isEmpty);
  });

  test('setFirstName should update firstName and notify listeners', () {
    taskProvider.addListener(() {}); // Ensure notifyListeners() is called

    taskProvider.setFirstName("John Doe");

    expect(taskProvider.firstName, "John Doe");
  });

  test('addTask should add a new task and notify listeners', () async {
    when(db.addTask(any, any)).thenAnswer((_) async => "task123");

    await taskProvider.addTask(
      "Test Task",
      "Work",
      "Description",
      "User123",
      DateTime.now(),
      "userA",
      true,
    );

    expect(taskProvider.tasks.length, 1);
    expect(taskProvider.tasks.first.title, "Test Task");
    verify(db.addTask(any, any)).called(1);
  });

  test('fetchPartnerships should retrieve partnerships', () async {
    expect(taskProvider.partnerships.length, 1);
    expect(taskProvider.partnerships.first.name, "Test Partnership");
  });

  test('deleteTask should remove task and notify listeners', () async {
    when(db.deleteTask(any, any)).thenAnswer((_) async {});

    taskProvider.tasks.add(TaskDetails(
        id: "task1",
        title: "Test Task",
        category: "Work",
        description: "test",
        createdBy: "test user",
        endTime: DateTime.now(),
        isCompleted: false,
        assignedTo: "test user"));

    await taskProvider.deleteTask("task1");

    expect(taskProvider.tasks, isEmpty);
    verify(db.deleteTask(any, any)).called(1);
  });

  test("getTasksForDate should get's today's tasks", () async {
    taskProvider.tasks.add(TaskDetails(
        id: "task1",
        title: "Test Task",
        category: "Work",
        description: "test",
        createdBy: "test user",
        endTime: DateTime.now(),
        isCompleted: false,
        assignedTo: "test user"));

    expect(taskProvider.getTasksForDate(DateTime.now()).length, 1);
  });

  test("create partnership creates and joins partnership", () async {
    expect(taskProvider.partnerships.length, 1);
    await taskProvider.createPartnership("Test partnership");
    expect(taskProvider.partnerships.length, 2);
    List<String> partnershipNames = taskProvider.partnerships
        .map((partnership) => partnership.name)
        .toList();
    expect(partnershipNames.contains("Test partnership"), true);
  });

  test("joinPartnershipWithCode errors for invalid queries", () async {
    when(db.findPartnershipWithCode("INVALID CODE !!"))
        .thenAnswer((_) async => "-1");
    expect(taskProvider.joinPartnership("INVALID CODE !!"), throwsException);
  });

  test("change completion changes completion of task properly", () async {
    taskProvider.tasks.add(TaskDetails(
        id: "task1",
        title: "Test Task",
        category: "Work",
        description: "test",
        createdBy: "test user",
        endTime: DateTime.now(),
        isCompleted: false,
        assignedTo: "test user"));
    List<bool> completed = taskProvider.tasks.map((task) => task.isCompleted).toList();
    int numCompleted = completed.where((t) => t).length;
    expect(numCompleted, 0);
    print(taskProvider.tasks);
    await taskProvider.changeCompletion('task1');
    print(taskProvider.tasks);
    completed = taskProvider.tasks.map((task) => task.isCompleted).toList();
    numCompleted = completed.where((t) => t).length;
    expect(numCompleted, 1);
  });

  test("getOngoingTasks correctly returns currently ongoing tasks", () async {
    taskProvider.tasks.add(TaskDetails(
        id: "task1",
        title: "Test Task",
        category: "Work",
        description: "test",
        createdBy: "test user",
        startTime: DateTime.now().subtract(const Duration(minutes: 10)),
        endTime: DateTime.now().add(const Duration(minutes: 30)),
        isCompleted: false,
        assignedTo: "test user"));
    expect(taskProvider
        .getOngoingTasks()
        .length, 1);
  });
  
}
