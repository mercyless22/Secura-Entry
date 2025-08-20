import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add Guest Entry
  Future<void> addGuest(String name, String phone, String residentId) async {
    await _firestore.collection('guests').add({
      'name': name,
      'phone': phone,
      'residentId': residentId,
      'timestamp': DateTime.now(),
    });
  }

  // Fetch Guest Logs
  Stream<QuerySnapshot> getGuestLogs() {
    return _firestore.collection('guests').orderBy('timestamp', descending: true).snapshots();
  }
}
