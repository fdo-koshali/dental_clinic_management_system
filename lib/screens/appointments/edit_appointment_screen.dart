import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EditAppointmentScreen extends StatefulWidget {
  final String? appointmentId;

  const EditAppointmentScreen({
    Key? key,
    this.appointmentId,
  }) : super(key: key);

  @override
  State<EditAppointmentScreen> createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _selectedDentist;
  String? _selectedTreatment;

  List<String> _dentists = [];
  List<String> _treatments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Load dentists
      final dentistsDoc = await _firestore.collection('dentists').get();
      _dentists = dentistsDoc.docs.map((doc) => doc['name'] as String).toList();

      // Load treatments
      final treatmentsDoc = await _firestore.collection('treatments').get();
      _treatments =
          treatmentsDoc.docs.map((doc) => doc['name'] as String).toList();

      // Load appointment if editing
      if (widget.appointmentId != null) {
        final appointmentDoc = await _firestore
            .collection('appointments')
            .doc(widget.appointmentId)
            .get();

        if (appointmentDoc.exists) {
          final data = appointmentDoc.data()!;
          setState(() {
            _selectedDate = (data['date'] as Timestamp).toDate();
            _selectedTime = TimeOfDay(
              hour: data['hour'] ?? TimeOfDay.now().hour,
              minute: data['minute'] ?? TimeOfDay.now().minute,
            );
            _selectedDentist = data['dentist'];
            _selectedTreatment = data['treatment'];
          });
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveAppointment() async {
    if (_formKey.currentState!.validate()) {
      try {
        final appointmentData = {
          'date': Timestamp.fromDate(_selectedDate),
          'hour': _selectedTime.hour,
          'minute': _selectedTime.minute,
          'dentist': _selectedDentist,
          'treatment': _selectedTreatment,
          'lastUpdated': DateTime.now(),
        };

        if (widget.appointmentId != null) {
          await _firestore
              .collection('appointments')
              .doc(widget.appointmentId)
              .update(appointmentData);
        } else {
          await _firestore.collection('appointments').add(appointmentData);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment saved successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving appointment: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appointmentId != null
            ? 'Edit Appointment'
            : 'New Appointment'),
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
                        'Date & Time',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(
                          DateFormat('EEEE, MMMM d, yyyy')
                              .format(_selectedDate),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _selectDate(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.access_time),
                        title: Text(_selectedTime.format(context)),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _selectTime(context),
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
                        'Appointment Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedDentist,
                        decoration: const InputDecoration(
                          labelText: 'Select Dentist',
                          border: OutlineInputBorder(),
                        ),
                        items: _dentists.map((dentist) {
                          return DropdownMenuItem(
                            value: dentist,
                            child: Text(dentist),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDentist = value;
                          });
                        },
                        validator: (value) => value == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedTreatment,
                        decoration: const InputDecoration(
                          labelText: 'Select Treatment',
                          border: OutlineInputBorder(),
                        ),
                        items: _treatments.map((treatment) {
                          return DropdownMenuItem(
                            value: treatment,
                            child: Text(treatment),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTreatment = value;
                          });
                        },
                        validator: (value) => value == null ? 'Required' : null,
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
                      onPressed: _saveAppointment,
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
}
