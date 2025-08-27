import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import '../api/api_client.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late ApiClient apiClient;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    apiClient = ApiClient(dio);
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final response = await apiClient.loginUser({
        "email": email,
        "password": password,
      });

      // ✅ Expecting response with token and userId
      if (response.token != null && response.token!.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", response.token!);
        if (response.userId != null) {
          await prefs.setString("userId", response.userId!);
        }

        // ✅ Update AuthProvider immediately
        if (!mounted) return;
        final authProvider = context.read<AuthProvider>();
        authProvider.saveAuthData(
          response.token!,
          //response.userId ?? "",
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed: token missing')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(217, 214, 191, 175),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 30),
            const Text(
              'Hello Again!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text('Welcome back you’ve been missed!'),
            const SizedBox(height: 30),

            // Email
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration('Email'),
            ),
            const SizedBox(height: 20),

            // Password
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration('Password'),
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _login,
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Color(0xFFD6BFAF)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return const InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFFD6BFAF), width: 2),
      ),
    ).copyWith(hintText: hint);
  }
}
