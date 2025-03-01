import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  List<String> _passwordErrors = [];
  String? _emailError;
  String? _usernameError;
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

  // Function to check if inputs are valid
  void _validateInputs() {
    setState(() {
      _generalError = null; // Reset error message
      _usernameError =
          _usernameController.text.isEmpty ? "Username cannot be empty" : null;
    });

    // Check if username is empty or passwords don't match
    if (_usernameController.text.isEmpty ||
        _passwordErrors.isNotEmpty ||
        _passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _generalError = "Invalid username or password"; // Display error message
      });
    } else {
      // Continue with the signup process (e.g., API call)
      print("User registered successfully!");
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

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _validateInputs,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  "Sign Up",
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
