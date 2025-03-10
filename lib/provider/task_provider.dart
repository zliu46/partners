import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partners/provider/noti_service.dart';
import '../model/partnership.dart';
import '../model/task_category.dart';
import '../model/task_details.dart';
import 'auth_service.dart';
import 'database_service.dart';

class TaskProvider extends ChangeNotifier {
  // Implement a database
  final DatabaseService _db = DatabaseService();
  final AuthService _auth = AuthService();
  final NotiService _notiService = NotiService();

  List<TaskDetails> _tasks = [];
  List<TaskCategory> _categories = [];
  late String _firstName;
  late String _username;
  late List<Partnership> _partnerships;
  late Partnership _currentPartnership;

  late int _currentPartnershipIndex;
  int get currentPartnershipIndex => _currentPartnershipIndex;



  String get firstName => _firstName;

  String get username => _username;

  List<Partnership> get partnerships => _partnerships;

  Partnership get currentPartnership => _currentPartnership;
  String? _partnershipId;

  String? get partnershipId => _partnershipId;

  void setPartnershipId(String id) {
    _partnershipId = id;
    notifyListeners();
  }

  late UserCredential user;

  // document id for current partnership, set with .setPartnership()

  //String? get currentPartnership => currentPartnership;

  /// **Set the current user's first name**
  void setFirstName(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  /// **Set the current partnership**
  Future<void> setCurrentPartnership(int index) async {
    _currentPartnership = partnerships[index];
    _currentPartnershipIndex = index;
    notifyListeners();
  }

  Future<void> setUser(UserCredential user) async {
    user = user;
    var userDoc = await _db.findUser(user.user!.uid);
    setFirstName(userDoc.data()['first_name']);
    setUsername(userDoc.id);
  }

  List<TaskDetails> getTasksByCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  // Get Categories
  List<TaskCategory> get categories => _categories;

  // Get Tasks
  List<TaskDetails> get tasks => _tasks;

  // Get Ongoing Tasks (Tasks that have started but are not completed)
  List<TaskDetails> get ongoingTasks => _tasks
      .where((task) =>
          (task.startTime ?? task.endTime).isBefore(DateTime.now()) &&
          !task.isCompleted)
      .toList();

  // Get Upcoming Tasks (Tasks that are scheduled for later)
  List<TaskDetails> get upcomingTasks => _tasks
      .where((task) =>
          (task.startTime ?? task.endTime).isAfter(DateTime.now()) &&
          !task.isCompleted)
      .toList();

  // Get Task Count by Category
  int getTaskCount(String categoryTitle) {
    return _tasks.where((task) => task.category == categoryTitle).length;
  }

  // Add a New Task to Firestore
  Future<void> addTask(String title, String category, String description,
      String createdBy, DateTime startTime, assignedTo, bool enableNotification,
      [DateTime? endTime]) async {
    Map<String, dynamic> data = {
      'title': title,
      'category': category,
      'description': description,
      'createdBy': createdBy,
      'startTime': startTime,
      'endTime': endTime,
      'isCompleted': false,
      'assignedTo': assignedTo,
    };

    String id = await _db.addTask(data, _currentPartnership.id);
    data['id'] = id;
    _tasks.add(TaskDetails.fromMap(data));
    notifyListeners();

    /// Schedule notification
    /// make sure start time is in the future
    if (enableNotification && startTime.isAfter(DateTime.now())) {
      await _notiService.scheduleTaskNotification(
        id: id.hashCode,
        title: "Upcoming Task Reminder",
        body: "Your task '$title'",
        hour: startTime.hour,
        minute: startTime.minute,
        second: 05,
      );
    }
  }

  //  Delete a Task
  Future<void> deleteTask(String taskId) async {
    _db.deleteTask(taskId, _currentPartnership.id);
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  //  Add a New Category
  // TODO: check if category already exists
  void addCategory(String title, Color color) {
    categories.add(TaskCategory(title: title, color: color));
    _db.addCategory(
        {'name': title, 'color': color.value}, _currentPartnership.id);
    notifyListeners();
  }

  List<TaskDetails> getOngoingTasks() {
    final now = DateTime.now();
    return _tasks.where((task) {
      final endTime = (task.startTime ?? task.endTime)
          .add(const Duration(minutes: 30)); //  Default 30 min duration
      return (task.startTime ?? task.endTime).isBefore(now) &&
          endTime.isAfter(now);
    }).toList();
  }

  List<TaskDetails> getUpcomingTasks() {
    final now = DateTime.now();
    return _tasks
        .where((task) => (task.startTime ?? task.endTime).isAfter(now))
        .toList();
  }

  Future<void> changeCompletion(String id) async {
    int index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      // Update database
      await _db.updateCompletion(id, _currentPartnership.id);
      notifyListeners();
      // Note: We don't need to update _tasks or call notifyListeners() again
      // The stream will handle that when the database changes propagate
    }
  }

  TaskDetails getTaskById(String id) {
    return _tasks.where((TaskDetails task) => task.id == id).toList()[0];
  }


  List<TaskDetails> getTasksForDate(DateTime selectedDate) {
    return _tasks.where((task) {
      return (task.startTime ?? task.endTime).year == selectedDate.year &&
          (task.startTime ?? task.endTime).month == selectedDate.month &&
          (task.startTime ?? task.endTime).day == selectedDate.day;
    }).toList();
  }

  //Fetch partnerships for user
  Future<void> fetchPartnerships() async {
    List<dynamic> partnerships = await _db.getPartnerships(username);
    _partnerships = [];
    for (String id in partnerships) {
      String name = await _db.getPartnershipWithId(id);
      _partnerships.add(Partnership(name, id));
    }
    print(_partnerships);
  }

  //Fetch Tasks from Firestore Live Stream
  void fetchTasks() {
    _db.fetchTasksStream(_currentPartnership.id).listen((taskList) {
      _tasks = taskList;
      notifyListeners();
    });
  }

  //Fetch categories from Firestore stream
  void fetchCategories() {
    _db.fetchCategoriesStream(_currentPartnership.id).listen((categories) {
      _categories = categories;
      notifyListeners();
    });
  }

  Future<bool> checkUsernameTaken(String username) async {
    return await _db.checkUsernameTaken(username);
  }

  Future<UserCredential> signIn(String email, String password) async {
    UserCredential user = await _auth.signIn(email, password);
    await setUser(user);
    return user;
  }

  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.signUp(email, password);
  }

  void addUser(String username, String email, String firstName,
      String lastName, String uid) {
    _db.addUser(username, email, firstName, lastName, uid);
  }

  Stream<Map<String, dynamic>> fetchPartnershipStream(String partnershipId) {
    return _db.fetchPartnershipStream(partnershipId);
  }

  Future<String> createPartnership(String partnershipName) async {
    String partnershipId = await _db.createPartnership(partnershipName);
    _db.joinPartnership(username, partnershipId);
    return partnershipId;
  }

  Future<void> joinPartnership(String code) async {
    String partnershipId = await _db.findPartnershipWithCode(code);
    if (partnershipId == "-1") {
      throw Exception('invalid code');
    }
    String name = await _db.joinPartnership(username, partnershipId);
    _partnerships.add(Partnership(name, partnershipId));
  }

  Future<bool> hasPartnerships() async {
    return (await _db.getPartnerships(username)).isNotEmpty;
  }

  /// Stream to fetch completed tasks from `DatabaseService`
  Stream<List<TaskDetails>> getCompletedTasksStream() {
    return _db.fetchCompletedTasksStream(_currentPartnership.id);
  }


  // return list of all users in partnership
  Future<List<String>> getPartnershipUsers() async {
    return await _db.getUsers(_currentPartnership.id);
  }
}
