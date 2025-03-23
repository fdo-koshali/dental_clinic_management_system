import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String? selectedAppointmentType;
  String? selectedTreatment;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? appointmentID;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController ageTypeController = TextEditingController();

  final List<String> appointmentTypes = ["Consultation", "Treatment"];
  final List<String> treatmentNames = [
    "Root Canal",
    "Tooth Extraction",
    "Dental Filling",
    "Teeth Whitening",
    "Braces",
    "Dental Implants",
    "Gum Surgery",
    "Wisdom Tooth Removal",
    "Crown Placement",
    "Bridges",
    "Veneers",
    "Scaling & Polishing",
    "Fluoride Treatment",
    "Pediatric Dentistry",
    "Orthodontics",
    "Periodontal Treatment",
    "Prosthodontics",
    "Endodontics",
    "Oral Surgery",
    "Preventive Dentistry"
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  void _generateAppointmentID() {
    setState(() {
      appointmentID = "APT-${DateTime.now().millisecondsSinceEpoch}";
    });
  }

  void _submitAppointment() {
    int? age = int.tryParse(ageController.text);
    String ageType = ageTypeController.text;

    if (selectedAppointmentType == null ||
        nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        ageController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null ||
        (selectedAppointmentType == "Treatment" && selectedTreatment == null)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    if (age == null ||
        (ageType == "Years" && (age < 0 || age > 150)) ||
        (ageType == "Months" && (age <= 0 || age > 11))) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid age. Please enter valid values.")));
      return;
    }

    // Process Appointment
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Appointment Scheduled Successfully!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Appointments")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Appointment Type"),
                items: appointmentTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) =>
                    setState(() => selectedAppointmentType = value),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: "Patient's Name", hintText: "Example: John Doe"),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: "Mobile Number"),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Age"),
                    ),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: ageTypeController.text.isEmpty
                        ? null
                        : ageTypeController.text,
                    hint: Text("Select"),
                    items: ["Years", "Months"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        ageTypeController.text = newValue!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (selectedAppointmentType == "Treatment")
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Treatment Name"),
                  items: treatmentNames.map((treatment) {
                    return DropdownMenuItem(
                        value: treatment, child: Text(treatment));
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => selectedTreatment = value),
                ),
              SizedBox(height: 10),
              ListTile(
                title: Text(selectedDate == null
                    ? "Select Date"
                    : "Date: ${selectedDate!.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text(selectedTime == null
                    ? "Select Time"
                    : "Time: ${selectedTime!.format(context)}"),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _generateAppointmentID,
                child: Text("Press here to generate appointment ID"),
              ),
              if (appointmentID != null)
                Text("Generated ID: $appointmentID",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitAppointment,
                  child:
                      Text("Book Appointment", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
