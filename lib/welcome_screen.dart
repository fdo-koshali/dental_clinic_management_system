import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dental_clinic_management_system/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int currentDot = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  void startAnimation() {
    int rounds = 0;
    timer = Timer.periodic(Duration(milliseconds: 400), (Timer t) {
      if (!mounted) return;
      setState(() {
        currentDot = (currentDot + 1) % 5; // Cycle through 5 dots
      });

      if (currentDot == 4) {
        rounds++; // Count completed rounds
      }

      if (rounds >= 2) {
        t.cancel(); // Stop animation after 2 rounds

        if (mounted) {
          Future.delayed(Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome Image
            Image.asset('assets/images/Welcome.png', width: 400, height: 500),
            SizedBox(height: 20),

            // Centered Welcome Text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "WELCOME!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 30),

            // Loading Dots Animation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return AnimatedOpacity(
                  duration: Duration(milliseconds: 400),
                  opacity: currentDot == index ? 1.0 : 0.3, // Blinking effect
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
