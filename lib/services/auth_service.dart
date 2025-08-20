import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register User
  Future<String?> registerUser(String email, String password, String name, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'role': role, // resident, guard, admin
          'createdAt': DateTime.now(),
        });

        return null; // Success
      }
      return "Registration failed";
    } catch (e) {
      return e.toString();
    }
  }

  // Login User
  Future<String?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
    //    SharedPreferences prefs = await SharedPreferences.getInstance();
     //   DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        // if (userDoc.exists) {
        //   await prefs.setString('role', userDoc['role']);
        // }

        return null; // Success
      }
      return "Login failed";
    } catch (e) {
      return e.toString();
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Get Current User
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
