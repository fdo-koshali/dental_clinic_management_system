import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppointmentConfirmationScreen extends StatelessWidget {
  final String appointmentId;
  final String patientName;
  final String appointmentType;
  final String? treatmentType;
  final DateTime dateTime;
  final String dentistName;

  const AppointmentConfirmationScreen({
    Key? key,
    required this.appointmentId,
    required this.patientName,
    required this.appointmentType,
    this.treatmentType,
    required this.dateTime,
    required this.dentistName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/animations/success.json',
                      width: 200,
                      height: 200,
                      repeat: false,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Appointment Confirmed!',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                    ),
                    const SizedBox(height: 32),
                    _buildDetailCard(context),
                    const SizedBox(height: 24),
                    const Text(
                      'You will receive a confirmation message shortly.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Back to Home'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Appointment ID', appointmentId),
            const Divider(),
            _buildDetailRow('Patient Name', patientName),
            const Divider(),
            _buildDetailRow('Type', appointmentType),
            if (treatmentType != null) ...[
              const Divider(),
              _buildDetailRow('Treatment', treatmentType!),
            ],
            const Divider(),
            _buildDetailRow(
              'Date & Time',
              '${_formatDate(dateTime)} at ${_formatTime(dateTime)}',
            ),
            const Divider(),
            _buildDetailRow('Dentist', dentistName),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
