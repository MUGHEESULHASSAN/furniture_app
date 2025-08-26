import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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

  bool get isAuthenticated => _token != null;

  // ✅ Register
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

      print("Register Response token: ${response.token}");
      print("Register Response userId: ${response.userId}");
      print("Register Response user: ${response.user}");

      _token = response.token;
      _userId = response.userId;
      _user = response.user;

      notifyListeners();
      return true;
    } catch (e) {
      print("Error registering user: $e");
      return false;
    }
  }

  // ✅ Login
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

      print("Login Response token: ${response.token}");
      print("Login Response userId: ${response.userId}");
      print("Login Response user: ${response.user}");

      _token = response.token;
      _userId = response.userId;
      _user = response.user;

      notifyListeners();
      return true;
    } catch (e) {
      print("Error logging in: $e");
      return false;
    }
  }

  void logout() {
    _token = null;
    _userId = null;
    _user = null;
    notifyListeners();
  }
}
