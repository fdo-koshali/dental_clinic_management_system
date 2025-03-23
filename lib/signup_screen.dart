import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'login_screen.dart'; // Import the Login screen

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _mobileController =
      TextEditingController(); // Mobile number controller

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  List<String> _passwordErrors = [];
  String? _emailError;
  String? _usernameError;
  String? _mobileError; // Error for mobile number validation
  String? _generalError; // Stores "Invalid username or password" message

  // Email validation
  void _validateEmail(String email) {
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email)) {
      setState(() {
        _emailError = "Enter a valid email address";
      });
    } else {
      setState(() {
        _emailError = null;
      });
    }
  }

  // Password validation logic
  void _validatePassword(String password) {
    List<String> errors = [];

    if (password.length < 8) {
      errors.add("Must be at least 8 characters");
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      errors.add("Must contain an uppercase letter");
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      errors.add("Must contain a lowercase letter");
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      errors.add("Must contain a special character");
    }

    setState(() {
      _passwordErrors = errors;
    });
  }

  // Mobile number validation
  void _validateMobileNumber(String mobile) {
    if (!RegExp(r"^0[0-9]{9}$").hasMatch(mobile)) {
      setState(() {
        _mobileError = "Mobile number must start with 0 and be 10 digits long";
      });
    } else {
      setState(() {
        _mobileError = null; // No error if valid
      });
    }
  }

  // Function to check if inputs are valid
  void _validateInputs() {
    setState(() {
      _generalError = null; // Reset error message
      _usernameError =
          _usernameController.text.isEmpty ? "Username cannot be empty" : null;
    });

    // Check if username is empty, passwords don't match, or mobile number is invalid
    if (_usernameController.text.isEmpty ||
        _passwordErrors.isNotEmpty ||
        _passwordController.text != _confirmPasswordController.text ||
        _mobileError != null) {
      setState(() {
        _generalError = "Invalid username or password"; // Display error message
      });
    } else {
      // If everything is valid, call the save function
      _saveUserData();
    }
  }

  // Function to save user data to Firebase
  void _saveUserData() async {
    try {
      // Create a new user in Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Save the user data to Firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text,
        'username': _usernameController.text,
        'mobile': _mobileController.text,
      }).then((value) {
        // Show success message and navigate to the login screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have successfully registered')),
        );

        // Navigate back to the login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }).catchError((error) {
        setState(() {
          _generalError = "Error: $error";
        });
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _generalError = e.message; // Show Firebase auth error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Error Message
            if (_generalError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _generalError!,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),

            // Email Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(),
                errorText: _emailError,
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: _validateEmail,
            ),
            SizedBox(height: 15),

            // Username Field
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
                errorText: _usernameError, // Display username error
              ),
            ),
            SizedBox(height: 15),

            // Mobile Number Field
            TextField(
              controller: _mobileController, // Use mobile number controller
              decoration: InputDecoration(
                labelText: "Mobile number",
                border: OutlineInputBorder(),
                errorText: _mobileError, // Display mobile number error
              ),
              keyboardType:
                  TextInputType.phone, // Numeric input for mobile number
              onChanged: _validateMobileNumber, // Call the validation function
            ),
            SizedBox(height: 15),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              onChanged: _validatePassword,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 5),

            // Password Validation Messages
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _passwordErrors.map((error) {
                return Text(
                  "- $error",
                  style: TextStyle(color: Colors.red, fontSize: 14),
                );
              }).toList(),
            ),
            SizedBox(height: 10),

            // Confirm Password Field
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _validateInputs,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
