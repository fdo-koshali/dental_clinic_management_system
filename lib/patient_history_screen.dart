import 'package:flutter/material.dart';

class PatientHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> patientHistory = [
    {'date': '2024-02-15', 'treatment': 'Root Canal', 'dentist': 'Dr. Smith'},
    {'date': '2024-01-10', 'treatment': 'Teeth Cleaning', 'dentist': 'Dr. Johnson'},
    {'date': '2023-12-05', 'treatment': 'Tooth Extraction', 'dentist': 'Dr. Lee'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient History')),
      body: ListView.builder(
        itemCount: patientHistory.length,
        itemBuilder: (context, index) {
          final history = patientHistory[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(history['treatment']!),
              subtitle: Text("Dentist: ${history['dentist']}\nDate: ${history['date']}"),
              leading: Icon(Icons.medical_services, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
