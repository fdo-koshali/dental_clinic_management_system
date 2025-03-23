import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text("Enable Notifications"),
            subtitle: Text("Receive appointment reminders"),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text("Dark Mode"),
            subtitle: Text("Enable dark theme"),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Change Password"),
            onTap: () {
              // Navigate to Change Password screen (to be implemented)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Change Password feature coming soon!")),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About App"),
            onTap: () {
              // Navigate to About Us screen
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
    );
  }
}
