import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dental_clinic_management_system/splash_screen.dart';
import 'package:dental_clinic_management_system/welcome_screen.dart';
import 'package:dental_clinic_management_system/internet_connection_error.dart';
import 'package:dental_clinic_management_system/home_screen.dart';
import 'package:dental_clinic_management_system/appointment_screen.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(), // Starts with SplashScreen
        '/welcome': (context) => const WelcomeScreen(),
        '/noInternet': (context) => const InternetConnectionError(),
        '/home': (context) => HomeScreen(),
        '/appointments': (context) => AppointmentScreen(),
      },
    );
  }
}
