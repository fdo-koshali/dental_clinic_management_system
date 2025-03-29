import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';
=======
import '../models/user_model.dart';
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

<<<<<<< HEAD
  void _logError(String message, dynamic error) {
    debugPrint('$message: $error');
  }

  // Sign in with email and password
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      _logError('Error signing in', e);
      return null;
    }
  }

  // Sign up with role
=======
  // Sign up with email and password
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
<<<<<<< HEAD
    required UserRole role,
    String? phoneNumber,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
=======
    UserRole role = UserRole.user,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
        email: email,
        password: password,
      );

<<<<<<< HEAD
      if (userCredential.user != null) {
        final userModel = UserModel(
          uid: userCredential.user!.uid,
          email: email,
          name: name,
          role: role,
          phoneNumber: phoneNumber,
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
=======
      if (result.user != null) {
        UserModel userModel = UserModel(
          uid: result.user!.uid,
          email: email,
          name: name,
          role: role,
        );

        // Save user data to Firestore
        await _firestore
            .collection('users')
            .doc(result.user!.uid)
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
            .set(userModel.toMap());

        return userModel;
      }
<<<<<<< HEAD
      return null;
    } catch (e) {
      _logError('Error signing up', e);
      return null;
    }
=======
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
    return null;
  }

  // Sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Get user data from Firestore
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(result.user!.uid)
            .get();

        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
    return null;
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
<<<<<<< HEAD

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get current user with role
  Future<UserModel?> getCurrentUserModel() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
    }
    return null;
  }

  // Check if user has specific role
  Future<bool> hasRole(UserRole role) async {
    final userModel = await getCurrentUserModel();
    return userModel?.role == role;
  }

  // Password reset
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Change password
    Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        return true;
      }
      return false;
    } catch (e) {
      _logError('Error changing password', e);
      return false;
    }
  }
=======
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
}