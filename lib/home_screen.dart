import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dental_clinic_management_system/appointment_history_screen.dart';
import 'package:dental_clinic_management_system/appointment_screen.dart';
import 'package:dental_clinic_management_system/settings_screen.dart';
import 'package:dental_clinic_management_system/about_us_screen.dart';
import 'package:dental_clinic_management_system/login_screen.dart';
import 'package:dental_clinic_management_system/user_profile_screen.dart';
import 'package:dental_clinic_management_system/treatment_details_screen.dart';
import 'package:dental_clinic_management_system/patient_history_screen.dart';

Widget _buildDrawerItem(
    IconData icon, String title, BuildContext context, Widget destination) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    },
  );
}

class HomeScreen extends StatelessWidget {
  final List<String> imageUrls = [
    'assets/images/Image slider 01.jpg',
    'assets/images/Image slider 02.jpg',
    'assets/images/Image slider 03.jpeg',
    'assets/images/Image slider 04.jpg',
    'assets/images/Image slider 05.jpg',
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.blue),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Welcome, User!",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.event, "Appointment history", context,
                AppointmentHistoryScreen()),
            _buildDrawerItem(
                Icons.settings, "Settings", context, SettingsScreen()),
            _buildDrawerItem(Icons.info, "About Us", context, AboutUsScreen()),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Log Out", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomIcon(
                  context, Icons.event, AppointmentHistoryScreen()),
              _buildBottomIcon(context, Icons.person, UserProfileScreen()),
              _buildBottomIcon(context, Icons.history, PatientHistoryScreen()),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                  autoPlay: true,
                  height: 300,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9),
              items: imageUrls.map((image) {
                return Container(
                  margin: EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(image,
                        fit: BoxFit.cover, width: double.infinity),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 80),
            _buildMainButton(context, "Make Appointments", AppointmentScreen()),
            SizedBox(height: 15),
            _buildMainButton(
                context, "Treatment Details", TreatmentDetailsScreen()),
            SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomIcon(BuildContext context, IconData icon, Widget screen) {
    return IconButton(
      icon: Icon(icon, size: 30, color: Colors.blue),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }

  Widget _buildMainButton(BuildContext context, String label, Widget screen) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15)),
        child: Text(label, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
