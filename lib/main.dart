import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'firebase_options.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
=======
import 'package:dental_clinic_management_system/screens/splash/splash_screen.dart';
import 'package:dental_clinic_management_system/screens/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'Dental Clinic Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash, 
      routes: AppRoutes.getRoutes(),
=======
      title: 'Dentos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
      },
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
    );
  }
}