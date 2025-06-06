import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result.user != null;
    } catch (e) {
      print('Debug login error: $e'); 
      return false;
    }
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      if (email.isEmpty ||
          password.isEmpty ||
          name.isEmpty ||
          phoneNumber.isEmpty) {
        throw FirebaseAuthException(
          code: 'invalid-input',
          message: 'All fields are required',
        );
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'signup-failed',
          message: 'Failed to create user account',
        );
      }

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name.trim(),
        'email': email.trim(),
        'phoneNumber': phoneNumber.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'user',
        'isActive': true,
      });

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw FirebaseAuthException(
          code: 'data-store-failed',
          message: 'Failed to store user data',
        );
      }

      print('User created successfully with ID: ${userCredential.user!.uid}');
      return userCredential;
    } catch (e) {
      print('Signup error: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      print('Password reset email sent to: $email');
    } catch (e) {
      print('Password reset error: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? phoneNumber,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (displayName != null) {
          await user.updateDisplayName(displayName);
        }

        await _firestore.collection('users').doc(user.uid).update({
          if (displayName != null) 'name': displayName,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Profile update error: $e');
      rethrow;
    }
  }
}
