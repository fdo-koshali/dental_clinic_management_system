import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'login_screen.dart';

class InternetConnectionError extends StatefulWidget {
  const InternetConnectionError({super.key});

  @override
  InternetConnectionErrorState createState() => InternetConnectionErrorState();
}

class InternetConnectionErrorState extends State<InternetConnectionError> {
  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    List<ConnectivityResult> validConnections = [
      ConnectivityResult.wifi,
      ConnectivityResult.mobile,
      ConnectivityResult.ethernet
    ];

    if (validConnections.contains(connectivityResult)) {
      if (!mounted) return;
      // Internet Restored → Go to Login Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // No Internet → Keep Checking Every 3 Seconds
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) checkInternetConnection();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.red, size: 100),
            SizedBox(height: 20),
            Text(
              "No Internet Connection",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Please check your internet connection and try again.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkInternetConnection,
              child: Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
