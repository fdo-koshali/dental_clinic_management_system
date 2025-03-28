import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/dashboard/admin_dashboard.dart';
import '../screens/dashboard/patient_dashboard.dart';
import '../middleware/route_guard.dart';
import '../models/user_role.dart';
import '../screens/common/loading_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String adminDashboard = '/admin-dashboard';
  static const String dentistDashboard = '/dentist-dashboard';
  static const String assistantDashboard = '/assistant-dashboard';

  static Widget _buildProtectedRoute(BuildContext context, Widget destination, UserRole requiredRole) {
    return FutureBuilder(
      future: RouteGuard.canActivate(context, requiredRole),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }
        if (snapshot.hasData && snapshot.data == true) {
          return destination;
        }
        return const LoadingScreen();
      },
    );
  }

    static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignUpScreen(),
      home: (context) => _buildProtectedRoute(
        context,
        const PatientDashboard(),
        UserRole.patient,
      ),
      adminDashboard: (context) => _buildProtectedRoute(
        context,
        const AdminDashboard(),
        UserRole.admin,
      ),
      // ... similar updates for other routes ...
    };
  }
}