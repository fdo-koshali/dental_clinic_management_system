import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/splash_screen.dart';  // Add this import

class AppRoutes {
  static const String splash = '/';      // Add splash route
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),  // Add splash screen
      login: (context) => const LoginScreen(),
      signup: (context) => const SignUpScreen(),
    };
  }
}