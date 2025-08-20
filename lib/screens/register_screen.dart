import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final addressController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
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
            TextField(
              controller: usernameController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration('Username'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              style: const TextStyle(color: Colors.black),
              obscureText: true,
              decoration: _inputDecoration('Password'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration('Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration('Phone number'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: addressController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration('Address'),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () async {
                  final auth = Provider.of<AuthProvider>(context, listen: false);
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  final name = usernameController.text.trim();
                  final phone = phoneController.text.trim();
                  final address = addressController.text.trim();

                  if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty && phone.isNotEmpty && address.isNotEmpty) {
                    final prefs = await SharedPreferences.getInstance();

                    // Save data to SharedPreferences
                    await prefs.setString('email', email);
                    await prefs.setString('password', password);
                    await prefs.setString('name', name);
                    await prefs.setString('phone', phone);
                    await prefs.setString('address', address);

                    await auth.register(email, password);

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration successful! Please log in.')),
                    );

                    Navigator.pushReplacementNamed(context, '/login');
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all required fields')),
                    );
                  }
                },

                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Color(0xFFD6BFAF),
                  ),
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
