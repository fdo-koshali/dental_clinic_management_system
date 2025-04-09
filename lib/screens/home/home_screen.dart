import 'package:dental_clinic_management_system/screens/treatments/treatment_detail_screen.dart';
import 'package:dental_clinic_management_system/widgets/home/sidebar_menu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';
import 'image_slider.dart';
import '../appointments/appointment_screen.dart';
import '../special_notes/special_notes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkUserSession();
  }

  void _checkUserSession() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _showPatientIdDialog(BuildContext context, bool isAppointmentHistory) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String patientId = '';
        return AlertDialog(
          title: Text(isAppointmentHistory
              ? 'Enter Patient ID for Appointments'
              : 'Enter Patient ID'),
          content: TextField(
            decoration: const InputDecoration(
              labelText: 'Patient ID',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              patientId = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (isAppointmentHistory) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.appointmentHistory,
                    arguments: patientId,
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.patientHistory,
                    arguments: patientId,
                  );
                }
              },
              child: Text(isAppointmentHistory
                  ? 'View Appointment History'
                  : 'View Patient History'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dental Clinic'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SpecialNotesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: SidebarMenu(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 430,
                    child: const ImageSlider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Book Appointment'),
                            subtitle: const Text('Schedule your next visit'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AppointmentScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.medical_services),
                            title: const Text('Our Services'),
                            subtitle: const Text('View available treatments'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TreatmentDetailsScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomIcon(
                  icon: Icons.history,
                  label: 'Patient History',
                  onTap: () => _showPatientIdDialog(context, false),
                ),
                _buildBottomIcon(
                  icon: Icons.calendar_month,
                  label: 'Appointment History',
                  onTap: () => _showPatientIdDialog(context, true),
                ),
                _buildBottomIcon(
                  icon: Icons.person,
                  label: 'Profile',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
