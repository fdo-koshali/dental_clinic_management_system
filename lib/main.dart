import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dental_clinic_management_system/screens/splash/splash_screen.dart';
import 'package:dental_clinic_management_system/screens/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dentos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}