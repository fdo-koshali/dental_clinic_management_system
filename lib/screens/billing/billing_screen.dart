import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({Key? key}) : super(key: key);

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  
  final _appointmentIdController = TextEditingController();
  final _patientIdController = TextEditingController();
  final _appointmentChargeController = TextEditingController();
  final _investigationChargeController = TextEditingController();
  final _treatmentChargeController = TextEditingController();
  final _otherChargesController = TextEditingController();
  final _paymentController = TextEditingController();
  
  double _totalAmount = 0.0;
  double _balance = 0.0;

  @override
  void initState() {
    super.initState();
    _generatePatientId();
    _setupChargeListeners();
  }

  Future<void> _generatePatientId() async {
    final snapshot = await _firestore.collection('patients').get();
    final newId = 'P${(snapshot.docs.length + 1).toString().padLeft(4, '0')}';
    _patientIdController.text = newId;
  }

  void _setupChargeListeners() {
    void calculateTotal() {
      double appointmentCharge = double.tryParse(_appointmentChargeController.text) ?? 0;
      double investigationCharge = double.tryParse(_investigationChargeController.text) ?? 0;
      double treatmentCharge = double.tryParse(_treatmentChargeController.text) ?? 0;
      double otherCharges = double.tryParse(_otherChargesController.text) ?? 0;
      double payment = double.tryParse(_paymentController.text) ?? 0;

      setState(() {
        _totalAmount = appointmentCharge + investigationCharge + treatmentCharge + otherCharges;
        _balance = _totalAmount - payment;
      });
    }

    _appointmentChargeController.addListener(calculateTotal);
    _investigationChargeController.addListener(calculateTotal);
    _treatmentChargeController.addListener(calculateTotal);
    _otherChargesController.addListener(calculateTotal);
    _paymentController.addListener(calculateTotal);
  }

  void _saveBill() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestore.collection('bills').add({
          'appointmentId': _appointmentIdController.text,
          'patientId': _patientIdController.text,
          'appointmentCharge': double.parse(_appointmentChargeController.text),
          'investigationCharge': double.parse(_investigationChargeController.text),
          'treatmentCharge': double.parse(_treatmentChargeController.text),
          'otherCharges': double.parse(_otherChargesController.text),
          'totalAmount': _totalAmount,
          'payment': double.parse(_paymentController.text),
          'balance': _balance,
          'date': DateTime.now(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bill saved successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving bill: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _appointmentIdController,
                decoration: const InputDecoration(
                  labelText: 'Appointment ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _patientIdController,
                decoration: const InputDecoration(
                  labelText: 'Patient ID',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _appointmentChargeController,
                decoration: const InputDecoration(
                  labelText: 'Appointment Charge (Rs.)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _investigationChargeController,
                decoration: const InputDecoration(
                  labelText: 'Investigation Charge (Rs.)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _treatmentChargeController,
                decoration: const InputDecoration(
                  labelText: 'Treatment Charge (Rs.)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _otherChargesController,
                decoration: const InputDecoration(
                  labelText: 'Other Charges (Rs.)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Total Amount: Rs. $_totalAmount',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paymentController,
                decoration: const InputDecoration(
                  labelText: 'Payment (Rs.)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Balance: Rs. $_balance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _balance > 0 ? Colors.red : Colors.green,
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
                      onPressed: _saveBill,
                      child: const Text('Confirm'),
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
    _appointmentIdController.dispose();
    _patientIdController.dispose();
    _appointmentChargeController.dispose();
    _investigationChargeController.dispose();
    _treatmentChargeController.dispose();
    _otherChargesController.dispose();
    _paymentController.dispose();
    super.dispose();
  }
  
}