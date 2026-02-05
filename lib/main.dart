import 'package:flutter/material.dart';

import 'pages/camera_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/login_page.dart';
import 'pages/profile_page.dart';
import 'pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maestro Dev',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/camera': (context) => const CameraPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
