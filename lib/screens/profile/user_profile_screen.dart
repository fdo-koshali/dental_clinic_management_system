import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String id;
  final String name;
  final String brand;
  final int availability;
  final int stock;
  final int need;

  InventoryItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.availability,
    required this.stock,
    required this.need,
  });
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchQuery = '';

  Future<void> _saveInventory() async {
    try {
      // Save to Firebase
      await _firestore.collection('inventory').doc('current').set({
        'lastUpdated': DateTime.now(),
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inventory saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving inventory: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Items',
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('inventory_items').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final items = snapshot.data!.docs
                        .map((doc) => InventoryItem(
                              id: doc['id'],
                              name: doc['name'],
                              brand: doc['brand'],
                              availability: doc['availability'],
                              stock: doc['stock'],
                              need: doc['stock'] - doc['availability'],
                            ))
                        .where((item) => item.name
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();

                    return DataTable(
                      columns: const [
                        DataColumn(label: Text('Item ID')),
                        DataColumn(label: Text('Item Name')),
                        DataColumn(label: Text('Brand')),
                        DataColumn(label: Text('Availability')),
                        DataColumn(label: Text('Stock')),
                        DataColumn(label: Text('Need')),
                      ],
                      rows: items.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item.id)),
                            DataCell(Text(item.name)),
                            DataCell(Text(item.brand)),
                            DataCell(Text(item.availability.toString())),
                            DataCell(Text(item.stock.toString())),
                            DataCell(
                              Text(
                                item.need.toString(),
                                style: TextStyle(
                                  color: item.need > 0 ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveInventory,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}