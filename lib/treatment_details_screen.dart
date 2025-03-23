import 'package:flutter/material.dart';

class TreatmentDetailsScreen extends StatelessWidget {
  final List<Map<String, String>> treatments = [
    {"name": "Teeth Cleaning", "description": "A professional cleaning to remove plaque and tartar."},
    {"name": "Tooth Filling", "description": "A procedure to restore a decayed or damaged tooth."},
    {"name": "Root Canal", "description": "A treatment to save a severely infected tooth."},
    {"name": "Tooth Extraction", "description": "A procedure to remove a damaged or impacted tooth."},
    {"name": "Braces", "description": "Orthodontic treatment to align teeth and improve bite."},
  ];

  const TreatmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Treatment Details"),
      ),
      body: ListView.builder(
        itemCount: treatments.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(treatments[index]["name"]!),
              subtitle: Text(treatments[index]["description"]!),
              leading: Icon(Icons.medical_services, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
