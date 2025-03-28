import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text('Next Appointment: March 15, 2024 - 10:00 AM'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildDashboardCard(
                  context,
                  'Book Appointment',
                  Icons.calendar_today,
                  Colors.blue,
                  () => Navigator.pushNamed(context, '/book-appointment'),
                ),
                _buildDashboardCard(
                  context,
                  'My Appointments',
                  Icons.schedule,
                  Colors.green,
                  () => Navigator.pushNamed(context, '/my-appointments'),
                ),
                _buildDashboardCard(
                  context,
                  'Treatment History',
                  Icons.history,
                  Colors.orange,
                  () => Navigator.pushNamed(context, '/treatment-history'),
                ),
                _buildDashboardCard(
                  context,
                  'Medical Records',
                  Icons.folder_shared,
                  Colors.purple,
                  () => Navigator.pushNamed(context, '/medical-records'),
                ),
                _buildDashboardCard(
                  context,
                  'Prescriptions',
                  Icons.medical_services,
                  Colors.teal,
                  () => Navigator.pushNamed(context, '/prescriptions'),
                ),
                _buildDashboardCard(
                  context,
                  'Payments',
                  Icons.payment,
                  Colors.indigo,
                  () => Navigator.pushNamed(context, '/payments'),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionButton(
                  context,
                  'Emergency',
                  Icons.emergency,
                  Colors.red,
                  () => _showEmergencyDialog(context),
                ),
                _buildQuickActionButton(
                  context,
                  'Contact Us',
                  Icons.phone,
                  Colors.green,
                  () => _showContactDialog(context),
                ),
                _buildQuickActionButton(
                  context,
                  'Messages',
                  Icons.message,
                  Colors.blue,
                  () => Navigator.pushNamed(context, '/messages'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
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
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Contact'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('For dental emergencies, please call:'),
            SizedBox(height: 8),
            Text(
              '(123) 456-7890',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text('Available 24/7 for emergency care'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement call functionality
              Navigator.pop(context);
            },
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Us'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('(123) 456-7890'),
              subtitle: Text('Main Office'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('contact@dentalclinic.com'),
              subtitle: Text('Email'),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('123 Dental Street'),
              subtitle: Text('New York, NY 10001'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}