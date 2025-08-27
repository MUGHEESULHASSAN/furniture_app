import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // start loading saved auth data asynchronously
    _loadUserFromPrefs();
  }

  // ------------------ Public methods ------------------

  /// Public method to explicitly load token/userId from SharedPreferences
  Future<void> loadUser() async => await _loadUserFromPrefs();

  /// Save token and userId to SharedPreferences
  Future<void> saveAuthData(String token, String userId) async {
    _token = token;
    _userId = userId;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);
      await prefs.setString("userId", userId);
      debugPrint("AuthProvider: SAVED token=$_token userId=$_userId");
    } catch (e) {
      debugPrint("AuthProvider: error saving prefs: $e");
    }
    notifyListeners();
  }

  // ------------------ Private helpers ------------------

  /// Internal loader called by constructor and loadUser()
  Future<void> _loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");
      _userId = prefs.getString("userId");
      debugPrint("AuthProvider: LOADED token=$_token userId=$_userId");
      notifyListeners();
    } catch (e) {
      debugPrint("AuthProvider: error loading prefs: $e");
    }
  }

  // ------------------ Auth methods ------------------

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

      _token = response.token;
      _userId = response.userId;
      _user = response.user;

      await saveAuthData(_token ?? "", _userId ?? "");
      return true;
    } catch (e) {
      debugPrint("AuthProvider: Error registering user: $e");
      return false;
    } finally {
      notifyListeners();
    }
  }

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

      _token = response.token;
      _userId = response.userId;
      _user = response.user;

      await saveAuthData(_token ?? "", _userId ?? "");
      return true;
    } catch (e) {
      debugPrint("AuthProvider: Error logging in: $e");
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("token");
      await prefs.remove("userId");
    } catch (e) {
      debugPrint("AuthProvider: error clearing prefs: $e");
    }
    _token = null;
    _userId = null;
    _user = null;
    notifyListeners();
  }
}
