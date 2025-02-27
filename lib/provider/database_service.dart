import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/task_category.dart';
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

  Future<QueryDocumentSnapshot<Map<String, dynamic>>> findUser(
      String uid) async {
    return (await _db.collection('users').where('uid', isEqualTo: uid).get())
        .docs[0];
  }

  // if the username already exists, do not allow user to create account
  Future<bool> checkUsernameTaken(String username) async {
    return (await _db.collection('users').doc(username).get()).exists;
  }

  Future<String> addTask(
      Map<String, dynamic> data, String partnershipId) async {
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
  Future<void> updateCompletion(String taskId, String partnershipId) async {
    bool isCompleted = (await _db
            .collection('partnerships')
            .doc(partnershipId)
            .collection('tasks')
            .doc(taskId)
            .get())
        .get('isCompleted');
    _db
        .collection('partnerships')
        .doc(partnershipId)
        .collection('tasks')
        .doc(taskId)
        .update({'isCompleted': !isCompleted});
  }

  Stream<List<TaskDetails>> fetchTasksStream(String partnershipId) {
    return _db
        .collection('partnerships')
        .doc(partnershipId)
        .collection('tasks')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        data['startTime'] = data['startTime'].toDate();
        if (data['endTime'] != null){
          data['endTime'] = data['endTime'].toDate();
        } else {
          data['endTime'] = data['startTime'];
        }
        return TaskDetails.fromMap(data);
      }).toList();
    });
  }

  Stream<List<TaskCategory>> fetchCategoriesStream(String partnershipId) {
    return _db
        .collection('partnerships')
        .doc(partnershipId)
        .snapshots()
        .map((snapshot) {
      // Get the 'categories' field as a list of maps
      List<dynamic> categoriesList = snapshot.get('categories') ?? [];
      // Map each category to a TaskCategory object
      return categoriesList.map((category) {
        // Make sure 'category' is a Map and contains the necessary fields
        return TaskCategory(
          title: category['name'],
          color: Color(category['color']),
        );
      }).toList();
    });
  }

  Future<String> createPartnership(String partnershipName) async {
    Map<String, dynamic> data = {
      'groupname': partnershipName,
      'users': [],
      'categories': [],
      'secret_code': await generateUniqueCode()
    };
    var partnershipRef = await _db.collection('partnerships').add(data);
    return partnershipRef.id;
  }

  /// Generates a unique 7- or 8-digit code
  Future<String> generateUniqueCode() async {
    String code;
    bool exists;

    do {
      code = _generateRandomCode();
      exists = await _checkIfCodeExists(code);
    } while (exists);

    return code;
  }

  /// Generates a secure random 7 or 8-digit code
  String _generateRandomCode() {
    Random random = Random.secure();
    int length = random.nextBool() ? 7 : 8; // Randomly choose 7 or 8 digits
    int min =
        pow(10, length - 1).toInt(); // Smallest number with 'length' digits
    int max =
        pow(10, length).toInt() - 1; // Largest number with 'length' digits
    return (random.nextInt(max - min) + min).toString();
  }

  /// Checks if the generated code already exists in Firestore
  Future<bool> _checkIfCodeExists(String code) async {
    QuerySnapshot query = await _db
        .collection('partnerships')
        .where('joinCode', isEqualTo: code)
        .limit(1)
        .get();

    return query.docs.isNotEmpty; // True if the code already exists
  }

  Stream<Map<String, dynamic>> fetchPartnershipStream(String partnershipId) {
    return _db
        .collection('partnerships')
        .doc(partnershipId)
        .snapshots()
        .map((snapshot) {
      Map<String, dynamic> data = snapshot.data() ?? {};
      return {
        'id': snapshot.id,
        'name': data['groupname'] ?? 'Unnamed Group',
        'users': List<String>.from(
            data['users'] ?? []), // Ensure it's a List<String>
        'secret_code': data['secret_code']
      };
    });
  }

  //TO DO
  joinPartnership(String username, String partnershipId) {
    _db.collection('users').doc(username).update({
      'partnerships': FieldValue.arrayUnion([partnershipId])
    });
    _db.collection('partnerships').doc(partnershipId).update({
      'users': FieldValue.arrayUnion([username])
    });
  }

  // returns partnership id of partnership with given code
  Future<String> findPartnershipWithCode(String code) async {
    var querySnapshot = await _db
        .collection('partnerships')
        .where('secret_code', isEqualTo: code)
        .limit(1)
        .get();
    print(querySnapshot.docs.first);
    if (querySnapshot.docs.isEmpty) {
      return "-1";
    }
    return querySnapshot.docs.first.id;
  }

  Future<List<dynamic>> getPartnerships(String username) async {
    var snapshot = await _db.collection('users').doc(username).get();
    return (snapshot).get('partnerships') ?? [];
  }


  Future<String> getPartnershipWithId(String id) async {
    return (await _db.collection('partnerships').doc(id).get())
        .data()!['groupname'];
  }


  Future<List<String>> getUsers(String partnershipId) async {
    DocumentSnapshot doc = await _db.collection('partnerships')
        .doc(partnershipId).get();
    return List.from(doc.get('users'));
  }

  Stream<List<TaskDetails>> fetchCompletedTasksStream(String partnershipId) {
    return _db
        .collection('partnerships')
        .doc(partnershipId)
        .collection('tasks')
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        data['startTime'] = data['startTime'].toDate();
        if (data['endTime'] != null){
          data['endTime'] = data['endTime'].toDate();
        } else {
          data['endTime'] = data['startTime'];
        }
        return TaskDetails.fromMap(data);
      }).toList();
    });
  }
}
