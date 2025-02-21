import 'package:cloud_firestore/cloud_firestore.dart';

class PartnershipsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> createPartnership(String userId, String partnershipName) async {
    try {
      DocumentReference partnershipRef = await _db.collection('partnerships').add({
        'groupname': partnershipName,
        'members': [userId],  // Ensure the user is added to members list
        'categories': [],
      });
      await _db.collection('users').doc('zhou').update({'partnershipId': partnershipRef.id});
      return partnershipRef.id;
    } catch (e) {
      print("Error creating partnership: $e");
      return null;
    }
  }

  /// **Join an existing partnership**
  Future<bool> joinPartnership(String userId, String partnershipId) async {
    try {
      DocumentReference partnershipRef = _db.collection('partnerships').doc(partnershipId);
      DocumentSnapshot doc = await partnershipRef.get();

      if (!doc.exists) return false; // Partnership does not exist

      await partnershipRef.update({
        'members': FieldValue.arrayUnion([userId])
      });

      await _db.collection('users').doc(userId).update({'partnershipId': partnershipId});

      return true;
    } catch (e) {
      print("Error joining partnership: $e");
      return false;
    }
  }

  /// **Leave a partnership**
  Future<bool> leavePartnership(String userId, String partnershipId) async {
    try {
      DocumentReference partnershipRef = _db.collection('partnerships').doc(partnershipId);

      await partnershipRef.update({
        'members': FieldValue.arrayRemove([userId])
      });

      await _db.collection('users').doc(userId).update({'partnershipId': null});

      return true;
    } catch (e) {
      print("Error leaving partnership: $e");
      return false;
    }
  }
  /// Fetches partnership details by its ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getPartnership(String partnershipId) async {
    try {
      return await _db.collection('partnerships').doc(partnershipId).get();
    } catch (e) {
      print("Error fetching partnership: $e");
      throw Exception("Failed to fetch partnership");
    }
  }

  Stream<DocumentSnapshot> getPartnershipStream(String partnershipId) {
    return FirebaseFirestore.instance
        .collection('partnerships')
        .doc(partnershipId)
        .snapshots(); // Listen for real-time updates
  }

  /// **Get partnership members**
  Future<List<Map<String, dynamic>>> getPartnershipMembers(String partnershipId) async {
    try {
      DocumentSnapshot doc = await _db.collection('partnerships').doc(partnershipId).get();
      if (!doc.exists) return [];

      List<dynamic> memberIds = doc['members'] ?? [];
      List<Map<String, dynamic>> members = [];

      for (String memberId in memberIds) {
        DocumentSnapshot userDoc = await _db.collection('users').doc(memberId).get();
        if (userDoc.exists) {
          members.add({
            'id': userDoc.id,
            'username': userDoc['username'] ?? 'Unknown',
            'email': userDoc['email'] ?? '',
          });
        }
      }

      return members;
    } catch (e) {
      print("Error fetching members: $e");
      return [];
    }
  }
}
