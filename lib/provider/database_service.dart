import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/task_details.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // adds a new user to firestore Users collection, assumes all info is valid
  addUser(String username, String email, String first_name, String last_name,
      String uid) {
    Map<String, dynamic> data = {
      "username": username,
      "email": email,
      "first_name": first_name,
      "last_name": last_name,
      "uid": uid,
      "friends": [],
      "partnerships": [],
    };

    _db.collection('users').doc(username).set(data);
  }

  // if the username already exists, do not allow user to create account
  Future<bool> checkUsernameTaken(String username) async {
    return (await _db.collection('users').doc(username).get()).exists;
  }

  Future<String> addTask(Map<String, dynamic> data, String partnershipId) async {
    DocumentReference docRef = await _db
        .collection('partnerships')
        .doc(partnershipId)
        .collection('tasks')
        .add(data);

    return docRef.id;
  }

  void deleteTask(String taskId, String partnershipId) {
    _db
        .collection('partnerships')
        .doc(partnershipId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  void addCategory(Map<String, dynamic> data, String partnershipId) {
    _db.collection('partnerships').doc(partnershipId).update({
      'categories': FieldValue.arrayUnion([data])
    });
  }

  // change completion value for a task by inverting its current value
  void updateCompletion(String taskId, String partnershipId) async {
    bool completed = (await _db
            .collection('partnerships')
            .doc(partnershipId)
            .collection('tasks')
            .doc('taskId')
            .get())
        .get('completed');
    _db
        .collection('partnerships')
        .doc(partnershipId)
        .collection('tasks')
        .doc('taskId')
        .update({'completed': !completed});
  }

  Stream<List<TaskDetails>> fetchTasksStream(String partnershipId) {
    return _db
        .collection('partnerships')
        .doc(partnershipId)
        .collection('tasks')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskDetails.fromMap(doc.data()))
          .toList();
    });
  }
}
