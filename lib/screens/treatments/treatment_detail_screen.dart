import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_treatment_details_screen.dart';

class TreatmentCategory {
  final String name;
  final List<Treatment> treatments;

  TreatmentCategory({
    required this.name,
    required this.treatments,
  });
}

class Treatment {
  final String name;
  final String category;
  final String indication;
  final String description;
  final String duration;
  final double cost;
  final int numberOfVisits;
  final String worstOutcome;

  Treatment({
    required this.name,
    required this.category,
    required this.indication,
    required this.description,
    required this.duration,
    required this.cost,
    required this.numberOfVisits,
    required this.worstOutcome,
  });
}

class TreatmentDetailsScreen extends StatefulWidget {
  const TreatmentDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentDetailsScreen> createState() => _TreatmentDetailsScreenState();
}

class _TreatmentDetailsScreenState extends State<TreatmentDetailsScreen> {
  String searchQuery = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<TreatmentCategory>> getTreatmentCategories() {
    return _firestore.collection('treatments').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TreatmentCategory(
          name: data['name'],
          treatments: (data['treatments'] as List).map((treatment) {
            return Treatment(
              name: treatment['name'],
              category: data['name'],
              indication: treatment['indication'],
              description: treatment['description'],
              duration: treatment['duration'],
              cost: treatment['cost'].toDouble(),
              numberOfVisits: treatment['numberOfVisits'],
              worstOutcome: treatment['worstOutcome'],
            );
          }).toList(),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditTreatmentDetailsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search treatments...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<TreatmentCategory>>(
              stream: getTreatmentCategories(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final categories = snapshot.data!;
                List<Treatment> allTreatments = [];
                for (var category in categories) {
                  allTreatments.addAll(category.treatments);
                }

                final filteredTreatments = searchQuery.isEmpty
                    ? allTreatments
                    : allTreatments
                        .where((treatment) => treatment.name
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList()
                  ..sort((a, b) => a.name.compareTo(b.name));

                if (searchQuery.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredTreatments.length,
                    itemBuilder: (context, index) {
                      return _buildTreatmentCard(
                          filteredTreatments[index], categories);
                    },
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...category.treatments
                            .map((treatment) =>
                                _buildTreatmentCard(treatment, categories))
                            .toList(),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentCard(
      Treatment treatment, List<TreatmentCategory> categories) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        title: Text(
          treatment.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(treatment.category),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                final category = categories.firstWhere(
                  (c) => c.name == treatment.category,
                );
                final treatmentIndex = category.treatments.indexWhere(
                  (t) => t.name == treatment.name,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTreatmentDetailsScreen(
                      categoryId: treatment.category,
                      existingTreatment: {
                        'name': treatment.name,
                        'indication': treatment.indication,
                        'description': treatment.description,
                        'duration': treatment.duration,
                        'cost': treatment.cost,
                        'numberOfVisits': treatment.numberOfVisits,
                        'worstOutcome': treatment.worstOutcome,
                      },
                      treatmentIndex: treatmentIndex,
                    ),
                  ),
                );
              },
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Indication', treatment.indication),
                _buildDetailRow('Description', treatment.description),
                _buildDetailRow('Duration', treatment.duration),
                _buildDetailRow(
                    'Cost', 'Rs. ${treatment.cost.toStringAsFixed(2)}'),
                _buildDetailRow(
                    'Number of Visits', treatment.numberOfVisits.toString()),
                _buildDetailRow('Worst Outcome', treatment.worstOutcome),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
