import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  AuthProvider() {
    _user = _authService.getCurrentUser();
  }

  User? get user => _user;

  Future<String?> register(String email, String password, String name, String role) async {
    String? result = await _authService.registerUser(email, password, name, role);
    if (result == null) {
      _user = _authService.getCurrentUser();
      notifyListeners();
    }
    return result;
  }

  Future<String?> login(String email, String password) async {
    String? result = await _authService.loginUser(email, password);
    if (result == null) {
      _user = _authService.getCurrentUser();
      notifyListeners();
    }
    return result;
  }

  void logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
