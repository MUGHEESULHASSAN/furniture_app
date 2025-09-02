import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'api/api_client.dart';

// Screens
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

// Theme
import 'theme/theme.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'providers/category_provider.dart';
import 'providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Allows async in main

  final dio = Dio();
  ApiClient(dio);

  // Create AuthProvider and load saved token/userId
  final authProvider = AuthProvider();
  await authProvider.loadUser(); // Explicit load before app starts

  runApp(
    MultiProvider(
      providers: [
        // Auth provider
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),

        // Order provider depends on Auth
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (ctx) => OrderProvider(authProvider),
          update: (ctx, auth, previous) => OrderProvider(auth),
        ),

        // Category provider (standalone)
        ChangeNotifierProvider(create: (_) => CategoryProvider()),

        // Cart provider (standalone)
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mosfurex',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
