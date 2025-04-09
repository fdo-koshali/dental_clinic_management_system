import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPatientHistoryScreen extends StatefulWidget {
  final String? patientId;

  const EditPatientHistoryScreen({
    Key? key,
    this.patientId,
  }) : super(key: key);

  @override
  State<EditPatientHistoryScreen> createState() => _EditPatientHistoryScreenState();
}

class _EditPatientHistoryScreenState extends State<EditPatientHistoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  final _oralExaminationController = TextEditingController();
  final _medicalHistoryController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _investigationsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.patientId != null) {
      _loadPatientHistory();
    }
  }

  Future<void> _loadPatientHistory() async {
    try {
      final doc = await _firestore
          .collection('patients')
          .doc(widget.patientId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _oralExaminationController.text = data['oralExamination'] ?? '';
          _medicalHistoryController.text = data['medicalHistory'] ?? '';
          _allergiesController.text = data['allergies'] ?? '';
          _investigationsController.text = data['investigations'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading patient history: $e')),
      );
    }
  }

  Future<void> _saveHistory() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestore.collection('patients').doc(widget.patientId).update({
          'oralExamination': _oralExaminationController.text,
          'medicalHistory': _medicalHistoryController.text,
          'allergies': _allergiesController.text,
          'investigations': _investigationsController.text,
          'lastUpdated': DateTime.now(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Patient history updated successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving patient history: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Patient History'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Oral Examination Findings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _oralExaminationController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Enter oral examination findings',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Past Medical History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _medicalHistoryController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Enter past medical history',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Allergies',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _allergiesController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'Enter allergies',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Investigations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _investigationsController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Enter investigations',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveHistory,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _oralExaminationController.dispose();
    _medicalHistoryController.dispose();
    _allergiesController.dispose();
    _investigationsController.dispose();
    super.dispose();
  }
}