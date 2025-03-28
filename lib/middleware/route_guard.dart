import 'package:flutter/material.dart';
import 'dart:async'; // Add this import
import '../services/auth_service.dart';
import '../models/user_role.dart';
import '../routes/app_routes.dart';

class RouteGuard {
  static const int timeoutSeconds = 10;

  static Future<bool> canActivate(BuildContext context, UserRole requiredRole) async {
    try {
      return await _checkAuthentication(context, requiredRole).timeout(
        Duration(seconds: timeoutSeconds),
        onTimeout: () {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Connection timed out. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
          return false;
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
      return false;
    }
  }

  static Future<bool> _checkAuthentication(BuildContext context, UserRole requiredRole) async {
    final authService = AuthService();
    final userModel = await authService.getCurrentUserModel();

    if (!context.mounted) return false;

    if (userModel == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return false;
    }

    if (userModel.role != requiredRole) {
      String route;
      switch (userModel.role) {
        case UserRole.admin:
          route = AppRoutes.adminDashboard;
          break;
        case UserRole.dentist:
          route = AppRoutes.dentistDashboard;
          break;
        case UserRole.assistant:
          route = AppRoutes.assistantDashboard;
          break;
        case UserRole.patient:
          route = AppRoutes.home;
          break;
      }
      Navigator.pushReplacementNamed(context, route);
      return false;
    }

    return true;
  }
}