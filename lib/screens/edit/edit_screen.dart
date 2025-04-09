import 'package:flutter/material.dart';
import '../treatments/edit_treatment_details_screen.dart';
import '../inventory/inventory_screen.dart';
import '../billing/billing_screen.dart';
import '../patient/edit_patient_history_screen.dart';
import '../appointments/edit_appointment_screen.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Options'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEditButton(
              context,
              icon: Icons.receipt_long,
              title: 'Billing',
              subtitle: 'Manage billing and payments',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BillingScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildEditButton(
              context,
              icon: Icons.medical_services,
              title: 'Treatment Details',
              subtitle: 'Edit treatment information',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditTreatmentDetailsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildEditButton(
              context,
              icon: Icons.history,
              title: 'Patient History',
              subtitle: 'Modify patient records',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditPatientHistoryScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildEditButton(
              context,
              icon: Icons.calendar_today,
              title: 'Appointments',
              subtitle: 'Update appointment schedule',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditAppointmentScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildEditButton(
              context,
              icon: Icons.inventory,
              title: 'Inventory',
              subtitle: 'Manage inventory items',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InventoryScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(
          icon,
          size: 32,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
      ),
    );
  }
}
