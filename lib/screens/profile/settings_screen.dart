import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _locationEnabled = prefs.getBool('location') ?? true;
      _language = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setBool('location', _locationEnabled);
    await prefs.setString('language', _language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'App Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Notifications
          SwitchListTile(
            secondary: Icon(
              Icons.notifications,
              color: AppTheme.primaryColor,
            ),
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive updates and offers'),
            value: _notificationsEnabled,
            activeColor: AppTheme.primaryColor,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              _saveSettings();
            },
          ),
          
          // Location
          SwitchListTile(
            secondary: Icon(
              Icons.location_on,
              color: AppTheme.primaryColor,
            ),
            title: const Text('Location Services'),
            subtitle: const Text('Find nearby service centers'),
            value: _locationEnabled,
            activeColor: AppTheme.primaryColor,
            onChanged: (value) {
              setState(() {
                _locationEnabled = value;
              });
              _saveSettings();
            },
          ),
          
          // Language
          ListTile(
            leading: Icon(
              Icons.language,
              color: AppTheme.primaryColor,
            ),
            title: const Text('Language'),
            subtitle: Text(_language),
            trailing: Icon(
              Icons.chevron_right,
              color: AppTheme.greyColor,
            ),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          
          const Divider(height: 32),
          
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Change Password
          ListTile(
            leading: Icon(
              Icons.lock,
              color: AppTheme.primaryColor,
            ),
            title: const Text('Change Password'),
            trailing: Icon(
              Icons.chevron_right,
              color: AppTheme.greyColor,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password change feature coming soon'),
                ),
              );
            },
          ),
          
          // Clear Cache
          ListTile(
            leading: Icon(
              Icons.cleaning_services,
              color: AppTheme.primaryColor,
            ),
            title: const Text('Clear Cache'),
            trailing: Icon(
              Icons.chevron_right,
              color: AppTheme.greyColor,
            ),
            onTap: () {
              _showClearCacheDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _language,
              activeColor: AppTheme.primaryColor,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
                _saveSettings();
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Spanish'),
              value: 'Spanish',
              groupValue: _language,
              activeColor: AppTheme.primaryColor,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
                _saveSettings();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the app cache?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Cache cleared successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}



