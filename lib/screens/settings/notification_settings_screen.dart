import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _appointmentReminders = true;
  bool _treatmentUpdates = true;
  bool _promotionalOffers = false;
  bool _emailNotifications = true;
  bool _smsNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Notification Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildNotificationSection(
            'Appointment Reminders',
            'Get notified about upcoming appointments',
            _appointmentReminders,
            (value) {
              setState(() => _appointmentReminders = value);
              _saveSettings();
            },
          ),
          _buildNotificationSection(
            'Treatment Updates',
            'Receive updates about your treatments',
            _treatmentUpdates,
            (value) {
              setState(() => _treatmentUpdates = value);
              _saveSettings();
            },
          ),
          _buildNotificationSection(
            'Promotional Offers',
            'Get notified about special offers and discounts',
            _promotionalOffers,
            (value) {
              setState(() => _promotionalOffers = value);
              _saveSettings();
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Notification Channels',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildNotificationSection(
            'Email Notifications',
            'Receive notifications via email',
            _emailNotifications,
            (value) {
              setState(() => _emailNotifications = value);
              _saveSettings();
            },
          ),
          _buildNotificationSection(
            'SMS Notifications',
            'Receive notifications via SMS',
            _smsNotifications,
            (value) {
              setState(() => _smsNotifications = value);
              _saveSettings();
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: _resetDefaultSettings,
              child: const Text('Reset to Default Settings'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _saveSettings() async {
    // TODO: Implement saving to Firebase/local storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _resetDefaultSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all notification settings to default?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _appointmentReminders = true;
                _treatmentUpdates = true;
                _promotionalOffers = false;
                _emailNotifications = true;
                _smsNotifications = true;
              });
              _saveSettings();
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}