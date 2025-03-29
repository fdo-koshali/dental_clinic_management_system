import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
<<<<<<< HEAD
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
=======

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
<<<<<<< HEAD
  final _authService = AuthService();
=======
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
<<<<<<< HEAD
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
=======
        child: Padding(
          padding: const EdgeInsets.all(20.0),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
<<<<<<< HEAD
                const SizedBox(height: 50),
                Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                ),
                const SizedBox(height: 50),
=======
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                ),
                const SizedBox(height: 40),
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
                      return 'Please enter a valid email';
                    }
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
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                    return null;
                  },
                ),
                const SizedBox(height: 20),
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
=======
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
<<<<<<< HEAD
                const SizedBox(height: 16),
=======
                const SizedBox(height: 10),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
<<<<<<< HEAD
                      // Navigate to forgot password screen
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 24),
=======
                      Navigator.pushNamed(context, '/forgot-password');
                    },
                    child: Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 20),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
<<<<<<< HEAD
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.signup);
                      },
                      child: const Text('Sign Up'),
=======
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Login'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text('Sign Up'),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
<<<<<<< HEAD
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final user = await _authService.signIn(
          _emailController.text,
          _passwordController.text,
        );
        if (user != null) {
          // Navigate to home screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
              backgroundColor: Colors.red,
            ),
=======
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        final user = await AuthService().signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
        
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid email or password')),
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
<<<<<<< HEAD

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
=======
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
}