import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
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
            const SizedBox(height: 20),
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Username
            TextField(
              controller: usernameController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration('Username'),
            ),
            const SizedBox(height: 10),

            // Password
            TextField(
              controller: passwordController,
              style: const TextStyle(color: Colors.black),
              obscureText: true,
              decoration: _inputDecoration('Password'),
            ),
            const SizedBox(height: 10),

            // Email
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration('Email'),
            ),
            const SizedBox(height: 10),

            // Phone
            TextField(
              controller: phoneController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration('Phone number'),
            ),
            const SizedBox(height: 20),

            // Register Button
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
                onPressed: _register,
                child: const Text(
                  'Register',
                  style: TextStyle(color: Color(0xFFD6BFAF)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = usernameController.text.trim();
    final phone = phoneController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final dio = Dio();
    final apiClient = ApiClient(dio);
    final user = User(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );

    try {
      await apiClient.registerUser(user.toJson());

      // Registration successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please log in.'),
        ),
      );

      // Navigate to login screen
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      if (e is DioError) {
        print('Dio Error: ${e.response?.data}');
        print('Dio Error Status Code: ${e.response?.statusCode}');
      } else {
        print('Error: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error registering user. Please try again.'),
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return const InputDecoration(
      hintText: '',
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
