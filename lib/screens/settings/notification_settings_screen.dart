import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _appointmentReminders = true;
  bool _promotionalNotifications = true;
  bool _emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Appointment Reminders'),
            subtitle: const Text('Get notified about upcoming appointments'),
            value: _appointmentReminders,
            onChanged: (bool value) {
              setState(() {
                _appointmentReminders = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Promotional Notifications'),
            subtitle: const Text('Receive updates about special offers'),
            value: _promotionalNotifications,
            onChanged: (bool value) {
              setState(() {
                _promotionalNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive notifications via email'),
            value: _emailNotifications,
            onChanged: (bool value) {
              setState(() {
                _emailNotifications = value;
              });
            },
          ),
        ],
      ),
    );
  }
}