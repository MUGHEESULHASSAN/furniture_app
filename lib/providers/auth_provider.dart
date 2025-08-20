import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _registeredEmail;
  String? _registeredPassword;

  AuthProvider() {
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    _registeredEmail = prefs.getString('email');
    _registeredPassword = prefs.getString('password');
  }

  Future<bool> register(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);

    _registeredEmail = email;
    _registeredPassword = password;

    notifyListeners();
    return true;
  }

  /// ✅ Now async
  Future<bool> login(String email, String password) async {
    await _loadCredentials(); // ensure latest data is loaded
    return email == _registeredEmail && password == _registeredPassword;
  }
}
