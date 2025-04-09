import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appointment_confirmation_screen.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late TwilioFlutter twilioFlutter;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _ageMonthsController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedAppointmentType;
  String? _selectedDentist;
  String? _selectedTreatment;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _showMonthField = true;

  final List<String> _appointmentTypes = ['Consultation', 'Treatment'];
  final List<String> _dentists = ['Dr. Charuka Fernando', 'Dr. John Doe'];
  final List<String> _treatments = [
    'Normal Scaling',
    'Stain removal scaling',
    'Normal filling',
    'Temperature filling',
    'Post core buildup',
    'Anterior Nerve filling',
    'Posterior nerve filling',
    'Normal tooth removal',
    'Surgical tooth removal',
  ];

  @override
  void initState() {
    super.initState();
    twilioFlutter = TwilioFlutter(
      accountSid: 'your_account_sid',
      authToken: 'your_auth_token',
      twilioNumber: 'your_twilio_number',
    );
  }

  bool _isValidAppointmentTime(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute;
    final timeInMinutes = hour * 60 + minute;

    const morningStart = 9 * 60; // 9 AM
    const morningEnd = 12 * 60; // 12 PM
    const afternoonStart = 14 * 60; // 2 PM
    const afternoonEnd = 16 * 60; // 4 PM
    const eveningStart = 17 * 60; // 5 PM
    const eveningEnd = 20 * 60; // 8 PM

    return (timeInMinutes >= morningStart && timeInMinutes < morningEnd) ||
        (timeInMinutes >= afternoonStart && timeInMinutes < afternoonEnd) ||
        (timeInMinutes >= eveningStart && timeInMinutes < eveningEnd);
  }

  bool _isValidDate(DateTime date) {
    return date.weekday != DateTime.sunday;
  }

  Future<void> _sendConfirmationSMS(
    String phoneNumber, {
    required String appointmentId,
    required String patientName,
    required String appointmentType,
    required DateTime dateTime,
    required String dentistName,
  }) async {
    final message = '''
Thank you for making an appointment at Dental Clinic!

Appointment Details:
ID: $appointmentId
Patient: $patientName
Type: $appointmentType
Date: ${DateFormat('yyyy-MM-dd').format(dateTime)}
Time: ${DateFormat('HH:mm').format(dateTime)}
Dentist: $dentistName

If you need to reschedule, please contact us.
''';

    try {
      await twilioFlutter.sendSMS(
        toNumber: phoneNumber,
        messageBody: message,
      );
    } catch (e) {
      print('Error sending SMS: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Appointment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Appointment Type',
                  border: OutlineInputBorder(),
                ),
                value: _selectedAppointmentType,
                items: _appointmentTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAppointmentType = value;
                    if (value == 'Consultation') {
                      _selectedTreatment = null;
                    }
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select appointment type' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Dentist',
                  border: OutlineInputBorder(),
                ),
                value: _selectedDentist,
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
                validator: (value) =>
                    value == null ? 'Please select a dentist' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        final age = int.tryParse(value);
                        setState(() {
                          _showMonthField = age == null || age <= 6;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter age';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (_showMonthField)
                    Expanded(
                      child: TextFormField(
                        controller: _ageMonthsController,
                        decoration: const InputDecoration(
                          labelText: 'Age (Months)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              if (_selectedAppointmentType == 'Treatment')
                Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Treatment',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedTreatment,
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
                      validator: (value) =>
                          _selectedAppointmentType == 'Treatment' &&
                                  value == null
                              ? 'Please select a treatment'
                              : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ListTile(
                title: const Text('Select Date'),
                subtitle: Text(
                  _selectedDate == null
                      ? 'No date selected'
                      : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                    selectableDayPredicate: (DateTime date) {
                      return _isValidDate(date);
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Select Time'),
                subtitle: Text(
                  _selectedTime == null
                      ? 'No time selected'
                      : _selectedTime!.format(context),
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    if (_isValidAppointmentTime(picked)) {
                      setState(() {
                        _selectedTime = picked;
                      });
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please select a time during clinic hours:\n'
                                '9:00 AM - 12:00 PM\n'
                                '2:00 PM - 4:00 PM\n'
                                '5:00 PM - 8:00 PM'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (_selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please select a date')),
                            );
                            return;
                          }
                          if (_selectedTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please select a time')),
                            );
                            return;
                          }

                          final appointmentDateTime = DateTime(
                            _selectedDate!.year,
                            _selectedDate!.month,
                            _selectedDate!.day,
                            _selectedTime!.hour,
                            _selectedTime!.minute,
                          );

                          final appointmentId =
                              'APT${DateTime.now().millisecondsSinceEpoch}';
                          final patientName =
                              '${_firstNameController.text} ${_lastNameController.text}';

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AppointmentConfirmationScreen(
                                appointmentId: appointmentId,
                                patientName: patientName,
                                appointmentType: _selectedAppointmentType!,
                                treatmentType: _selectedTreatment,
                                dateTime: appointmentDateTime,
                                dentistName: _selectedDentist!,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Confirm Appointment'),
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _ageMonthsController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
