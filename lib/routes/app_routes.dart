import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/dashboard/admin_dashboard.dart';
import '../screens/dashboard/dentist_dashboard.dart';
import '../screens/dashboard/assistant_dashboard.dart';
import '../screens/dashboard/patient_dashboard.dart';
import '../screens/common/loading_screen.dart';
import '../screens/common/network_error_screen.dart';
import '../middleware/route_guard.dart';
import '../models/user_role.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String adminDashboard = '/admin-dashboard';
  static const String dentistDashboard = '/dentist-dashboard';
  static const String assistantDashboard = '/assistant-dashboard';
  static const String networkError = '/network-error';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String appointments = '/appointments';
  static const String services = '/services';
  static const String history = '/history';
  static const String settings = '/settings';
  static const String bookAppointment = '/book-appointment';

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
        return const LoginScreen();
      },
    );
  }

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      welcome: (context) => const WelcomeScreen(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignUpScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      networkError: (context) => const NetworkErrorScreen(),
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
      dentistDashboard: (context) => _buildProtectedRoute(
        context,
        const DentistDashboard(),
        UserRole.dentist,
      ),
      assistantDashboard: (context) => _buildProtectedRoute(
        context,
        const AssistantDashboard(),
        UserRole.assistant,
      ),
    };
  }
}