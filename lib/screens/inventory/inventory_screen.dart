import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddItemDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedFilter == 'all',
                  onSelected: (selected) {
                    setState(() => _selectedFilter = 'all');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Low Stock'),
                  selected: _selectedFilter == 'low_stock',
                  onSelected: (selected) {
                    setState(() => _selectedFilter = 'low_stock');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Out of Stock'),
                  selected: _selectedFilter == 'out_of_stock',
                  onSelected: (selected) {
                    setState(() => _selectedFilter = 'out_of_stock');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('inventory').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var items = snapshot.data?.docs ?? [];

                if (_searchQuery.isNotEmpty) {
                  items = items.where((doc) {
                    final item = doc.data() as Map<String, dynamic>;
                    final name = item['name'].toString().toLowerCase();
                    return name.contains(_searchQuery.toLowerCase());
                  }).toList();
                }

                if (_selectedFilter != 'all') {
                  items = items.where((doc) {
                    final item = doc.data() as Map<String, dynamic>;
                    final quantity = item['quantity'] as int;
                    if (_selectedFilter == 'low_stock') {
                      return quantity > 0 && quantity <= 10;
                    } else if (_selectedFilter == 'out_of_stock') {
                      return quantity == 0;
                    }
                    return true;
                  }).toList();
                }

                if (items.isEmpty) {
                  return const Center(
                    child: Text('No items found'),
                  );
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index].data() as Map<String, dynamic>;
                    final quantity = item['quantity'] as int;
                    
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(item['name'] ?? 'No name'),
                        subtitle: Text('Quantity: $quantity'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('\$${item['price']?.toStringAsFixed(2) ?? '0.00'}'),
                            if (quantity <= 10)
                              const Icon(Icons.warning, color: Colors.orange),
                            if (quantity == 0)
                              const Icon(Icons.error, color: Colors.red),
                          ],
                        ),
                        onTap: () => _showEditItemDialog(items[index].id, item),
                      ),
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

  Future<void> _showAddItemDialog() async {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  quantityController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                await _firestore.collection('inventory').add({
                  'name': nameController.text.trim(),
                  'quantity': int.tryParse(quantityController.text) ?? 0,
                  'price': double.tryParse(priceController.text) ?? 0.0,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item added successfully')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditItemDialog(String itemId, Map<String, dynamic> item) async {
    final nameController = TextEditingController(text: item['name']);
    final quantityController = TextEditingController(text: item['quantity'].toString());
    final priceController = TextEditingController(text: item['price'].toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _firestore.collection('inventory').doc(itemId).update({
                'name': nameController.text.trim(),
                'quantity': int.tryParse(quantityController.text) ?? 0,
                'price': double.tryParse(priceController.text) ?? 0.0,
                'updatedAt': FieldValue.serverTimestamp(),
              });
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => _showDeleteConfirmation(itemId),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(String itemId) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _firestore.collection('inventory').doc(itemId).delete();
              if (!mounted) return;
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item deleted successfully')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
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