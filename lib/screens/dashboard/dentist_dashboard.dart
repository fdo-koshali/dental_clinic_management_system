import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class DentistDashboard extends StatelessWidget {
  const DentistDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dentist Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildDashboardCard(
            context,
            'My Appointments',
            Icons.calendar_today,
            Colors.blue,
            () => Navigator.pushNamed(context, '/my-appointments'),
          ),
          _buildDashboardCard(
            context,
            'Patient Records',
            Icons.folder_shared,
            Colors.green,
            () => Navigator.pushNamed(context, '/patient-records'),
          ),
          _buildDashboardCard(
            context,
            'Treatment Plans',
            Icons.medical_services,
            Colors.orange,
            () => Navigator.pushNamed(context, '/treatment-plans'),
          ),
          _buildDashboardCard(
            context,
            'Schedule',
            Icons.schedule,
            Colors.purple,
            () => Navigator.pushNamed(context, '/schedule'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}