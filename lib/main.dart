import 'package:dental_clinic_management_system/internet_connection_error.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dental Clinic Management System',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // Ensure this navigates properly
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/noInternet': (context) => const InternetConnectionError(),
      },
    );
  }
}
