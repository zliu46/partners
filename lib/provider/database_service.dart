import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // adds a new user to firestore Users collection, assumes all info is valid
  addUser(String username, String email, String first_name, String last_name,
      String uid) {
    Map<String, String> data = {
      "username": username,
      "email": email,
      "first_name": first_name,
      "last_name": last_name,
      "uid": uid
    };

    _db.collection('users').doc(username).set(data);
  }

  // if the username already exists, do not allow user to create account
  Future<bool> checkUsernameTaken(String username) async {
    return (await _db.collection('users').doc(username).get()).exists;
  }
}
