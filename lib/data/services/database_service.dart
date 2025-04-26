import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Create
  Future<void> createData(String path, Map<String, dynamic> data) async {
    await _database.child(path).push().set(data);
  }

  // Read
  Stream<DatabaseEvent> readData(String path) {
    return _database.child(path).onValue;
  }

  // Update
  Future<void> updateData(String path, Map<String, dynamic> data) async {
    await _database.child(path).update(data);
  }

  // Delete
  Future<void> deleteData(String path) async {
    await _database.child(path).remove();
  }
}
