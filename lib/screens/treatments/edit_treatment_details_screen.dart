import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTreatmentDetailsScreen extends StatefulWidget {
  final String? categoryId;
  final Map<String, dynamic>? existingTreatment;
  final int? treatmentIndex;

  const EditTreatmentDetailsScreen({
    Key? key,
    this.categoryId,
    this.existingTreatment,
    this.treatmentIndex,
  }) : super(key: key);

  @override
  State<EditTreatmentDetailsScreen> createState() =>
      _EditTreatmentDetailsScreenState();
}

class _EditTreatmentDetailsScreenState
    extends State<EditTreatmentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  String _selectedCategory = 'Scaling';
  final _nameController = TextEditingController();
  final _indicationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _costController = TextEditingController();
  final _visitsController = TextEditingController();
  final _worstOutcomeController = TextEditingController();

  final List<String> _categories = [
    'Scaling',
    'Fillings',
    'Nerve Filling',
    'Tooth Removals',
    'Orthodontic (Removable)',
    'Orthodontic (Non Removable)',
    'Bridges',
    'Habit Breakers',
    'Flexible Dentures',
    'Acrylic Dentures',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingTreatment != null) {
      _selectedCategory = widget.categoryId!;
      _nameController.text = widget.existingTreatment!['name'];
      _indicationController.text = widget.existingTreatment!['indication'];
      _descriptionController.text = widget.existingTreatment!['description'];
      _durationController.text = widget.existingTreatment!['duration'];
      _costController.text = widget.existingTreatment!['cost'].toString();
      _visitsController.text =
          widget.existingTreatment!['numberOfVisits'].toString();
      _worstOutcomeController.text = widget.existingTreatment!['worstOutcome'];
    }
  }

  void _saveTreatment() async {
    if (_formKey.currentState!.validate()) {
      try {
        final docRef = _firestore
            .collection('treatments')
            .doc(_selectedCategory.toLowerCase().replaceAll(' ', '_'));

        final docSnapshot = await docRef.get();
        List<Map<String, dynamic>> treatments = [];

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          treatments =
              List<Map<String, dynamic>>.from(data?['treatments'] ?? []);
        }

        final newTreatment = {
          'name': _nameController.text,
          'indication': _indicationController.text,
          'description': _descriptionController.text,
          'duration': _durationController.text,
          'cost': double.parse(_costController.text),
          'numberOfVisits': int.parse(_visitsController.text),
          'worstOutcome': _worstOutcomeController.text,
        };

        if (widget.treatmentIndex != null) {
          treatments[widget.treatmentIndex!] = newTreatment;
        } else {
          treatments.add(newTreatment);
        }

        await docRef.set({
          'name': _selectedCategory,
          'treatments': treatments,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.existingTreatment != null
                  ? 'Treatment updated successfully'
                  : 'Treatment saved successfully'),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving treatment: $e')),
          );
        }
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _indicationController.clear();
    _descriptionController.clear();
    _durationController.clear();
    _costController.clear();
    _visitsController.clear();
    _worstOutcomeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingTreatment != null
            ? 'Edit Treatment'
            : 'Add New Treatment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: widget.existingTreatment != null
                    ? null
                    : (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Treatment Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _indicationController,
                decoration: const InputDecoration(
                  labelText: 'Indication',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Cost (Rs.)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  if (double.tryParse(value!) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _visitsController,
                decoration: const InputDecoration(
                  labelText: 'Number of Visits',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  if (int.tryParse(value!) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _worstOutcomeController,
                decoration: const InputDecoration(
                  labelText: 'Worst Outcome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveTreatment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Treatment'),
              ),
              const SizedBox(height: 16),
              if (widget.existingTreatment == null)
                OutlinedButton(
                  onPressed: _clearForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Clear Form'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _indicationController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _costController.dispose();
    _visitsController.dispose();
    _worstOutcomeController.dispose();
    super.dispose();
  }
}
