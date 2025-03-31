import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedAppointmentType;
  String? _selectedDentist;
  String? _selectedTreatment;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

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
    // Add other treatments
  ];

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageYearsController = TextEditingController();
  final TextEditingController _ageMonthsController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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
                      controller: _ageYearsController,
                      decoration: const InputDecoration(
                        labelText: 'Age (Years)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
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
                      validator: (value) => _selectedAppointmentType == 'Treatment' && value == null
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
                    setState(() {
                      _selectedTime = picked;
                    });
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
                      onPressed: _handleSubmit,
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

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date')),
        );
        return;
      }
      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a time')),
        );
        return;
      }
      // TODO: Implement appointment creation logic
      // Generate appointment ID
      // Save to database
      // Send confirmation
      // Navigate to confirmation screen
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageYearsController.dispose();
    _ageMonthsController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}