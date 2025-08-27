import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../api/api_client.dart';
import '../models/user_model.dart' as model;
import '../models/auth_response.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _userId;
  model.User? _user;
  ApiClient apiClient = ApiClient(Dio());

  String? get token => _token;
  String? get userId => _userId;
  model.User? get user => _user;

  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  AuthProvider() {
    // Load saved auth data when provider is created
    _loadUserFromPrefs();
  }

  // ------------------ Persistence ------------------

  // Load token and decode userId
  Future<void> _loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");

      if (_token != null && _token!.isNotEmpty) {
        Map<String, dynamic> payload = Jwt.parseJwt(_token!);
        _userId = payload["userId"];
      }

      debugPrint("AuthProvider: LOADED token=$_token userId=$_userId");
      notifyListeners();
    } catch (e) {
      debugPrint("AuthProvider: error loading prefs: $e");
    }
  }

  // Save token and decode userId
  Future<void> saveAuthData(String token) async {
    _token = token;

    if (_token != null && _token!.isNotEmpty) {
      Map<String, dynamic> payload = Jwt.parseJwt(_token!);
      _userId = payload["userId"];
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);
      debugPrint("AuthProvider: SAVED token=$_token userId=$_userId");
    } catch (e) {
      debugPrint("AuthProvider: error saving prefs: $e");
    }

    notifyListeners();
  }

  // ------------------ Auth Methods ------------------

  // Register a new user
  Future<bool> register(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    try {
      final user = model.User(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );

      final formData = user.toJson();
      final AuthResponse response = await apiClient.registerUser(formData);

      if (response.token != null) {
        await saveAuthData(response.token!);
        _user = response.user;
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("AuthProvider: register error $e");
      return false;
    }
  }

  // Login existing user
  Future<bool> login(String email, String password) async {
    try {
      final user = model.User(
        email: email,
        password: password,
        name: "",
        phone: "",
      );

      final formData = user.toJson();
      final AuthResponse response = await apiClient.loginUser(formData);

      if (response.token != null) {
        await saveAuthData(response.token!);
        _user = response.user;
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("AuthProvider: login error $e");
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _user = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint("AuthProvider: error clearing prefs: $e");
    }
    notifyListeners();
  }

  // Optional: force reload token and userId
  Future<void> loadUser() async => await _loadUserFromPrefs();
}
