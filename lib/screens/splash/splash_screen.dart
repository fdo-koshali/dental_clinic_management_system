import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });

    if (isConnected) {
      // Navigate to welcome screen after 3 seconds
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/welcome');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/Splash screen icon.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            // Loading animation or network error
            if (isConnected)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  const Text(
                    'No Internet Connection',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: checkConnectivity,
                    child: const Text('Retry'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
