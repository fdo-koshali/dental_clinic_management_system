import 'package:flutter/material.dart';

class AppointmentHistoryScreen extends StatelessWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Appointment History")),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: 5, // Replace with actual appointment count
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Appointment ${index + 1}"),
              subtitle: Text("Date: 2024-03-08\nStatus: Completed"),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
          );
        },
      ),
    );
  }
}
