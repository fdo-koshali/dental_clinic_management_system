import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class AssistantDashboard extends StatelessWidget {
  const AssistantDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Assistant Name', // TODO: Replace with actual name
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
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
                  'Today\'s Schedule',
                  Icons.schedule,
                  Colors.blue,
                  () => Navigator.pushNamed(context, '/today-schedule'),
                ),
                _buildDashboardCard(
                  context,
                  'Patient Queue',
                  Icons.people,
                  Colors.green,
                  () => Navigator.pushNamed(context, '/patient-queue'),
                ),
                _buildDashboardCard(
                  context,
                  'Inventory',
                  Icons.inventory,
                  Colors.orange,
                  () => Navigator.pushNamed(context, '/inventory'),
                ),
                _buildDashboardCard(
                  context,
                  'Treatment Rooms',
                  Icons.meeting_room,
                  Colors.purple,
                  () => Navigator.pushNamed(context, '/treatment-rooms'),
                ),
                _buildDashboardCard(
                  context,
                  'Tasks',
                  Icons.task,
                  Colors.teal,
                  () => Navigator.pushNamed(context, '/tasks'),
                ),
                _buildDashboardCard(
                  context,
                  'Messages',
                  Icons.message,
                  Colors.indigo,
                  () => Navigator.pushNamed(context, '/messages'),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionButton(
                  context,
                  'Check In',
                  Icons.login,
                  () {
                    // Handle check-in
                  },
                ),
                _buildQuickActionButton(
                  context,
                  'Emergency',
                  Icons.emergency,
                  () {
                    // Handle emergency
                  },
                ),
                _buildQuickActionButton(
                  context,
                  'Support',
                  Icons.help,
                  () {
                    // Handle support
                  },
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
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}