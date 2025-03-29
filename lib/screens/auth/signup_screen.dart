import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
<<<<<<< HEAD
import '../../routes/app_routes.dart';
import '../../models/user_role.dart';
import '../../models/user_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
=======
import '../../models/user_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
<<<<<<< HEAD
  final _authService = AuthService();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  UserRole _selectedRole = UserRole.patient;
=======
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
=======
        title: Text('Create Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
<<<<<<< HEAD
          padding: const EdgeInsets.all(24.0),
=======
          padding: const EdgeInsets.all(20.0),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
<<<<<<< HEAD
                  height: 120,
=======
                  height: 100,
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
<<<<<<< HEAD
                    hintText: 'Enter your full name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
=======
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
<<<<<<< HEAD
                const SizedBox(height: 16),
=======
                const SizedBox(height: 20),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
<<<<<<< HEAD
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
=======
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email';
                    }
                    if (!value!.contains('@')) {
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
<<<<<<< HEAD
                const SizedBox(height: 16),
=======
                const SizedBox(height: 20),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
<<<<<<< HEAD
                    hintText: 'Enter your mobile number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
=======
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                      return 'Please enter your mobile number';
                    }
                    return null;
                  },
                ),
<<<<<<< HEAD
                const SizedBox(height: 16),
                DropdownButtonFormField<UserRole>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: UserRole.values.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role.name),
                    );
                  }).toList(),
                  onChanged: (UserRole? value) {
                    if (value != null) {
                      setState(() => _selectedRole = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
=======
                const SizedBox(height: 20),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
<<<<<<< HEAD
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock),
=======
                    prefixIcon: Icon(Icons.lock),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
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
                    border: OutlineInputBorder(
<<<<<<< HEAD
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
=======
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your password';
                    }
                    if (value!.length < 6) {
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
<<<<<<< HEAD
                const SizedBox(height: 16),
=======
                const SizedBox(height: 20),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
<<<<<<< HEAD
                    hintText: 'Confirm your password',
                    prefixIcon: const Icon(Icons.lock_outline),
=======
                    prefixIcon: Icon(Icons.lock),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
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
                    border: OutlineInputBorder(
<<<<<<< HEAD
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
=======
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
<<<<<<< HEAD
                const SizedBox(height: 24),
=======
                const SizedBox(height: 30),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
<<<<<<< HEAD
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Create Account',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.login);
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
=======
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Create Account'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
<<<<<<< HEAD
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final user = await _authService.signUp(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          role: _selectedRole,
          phoneNumber: _mobileController.text,
        );
        
        if (user != null && mounted) {
          switch (user.role) {
            case UserRole.admin:
              Navigator.pushReplacementNamed(context, '/admin-dashboard');
              break;
            case UserRole.dentist:
              Navigator.pushReplacementNamed(context, '/dentist-dashboard');
              break;
            case UserRole.assistant:
              Navigator.pushReplacementNamed(context, '/assistant-dashboard');
              break;
            case UserRole.patient:
            default:
              Navigator.pushReplacementNamed(context, '/home');
              break;
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create account'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
=======
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        final user = await AuthService().signUp(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
        );
        
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create account')),
          );
        }
      } finally {
        setState(() => _isLoading = false);
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
