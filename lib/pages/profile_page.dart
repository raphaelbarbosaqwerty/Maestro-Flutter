import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Semantics(
          identifier: 'profile_back_button',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Avatar Section
            Center(
              child: Column(
                children: [
                  Semantics(
                    identifier: 'profile_avatar',
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    identifier: 'profile_name_text',
                    child: const Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Semantics(
                    identifier: 'profile_email_text',
                    child: const Text(
                      'john.doe@example.com',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Settings Section
            Semantics(
              identifier: 'profile_settings_header',
              child: const Text(
                'Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Notifications Toggle
            Semantics(
              identifier: 'profile_notifications_toggle',
              child: SwitchListTile(
                title: const Text('Notifications'),
                subtitle: const Text('Receive push notifications'),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                },
              ),
            ),

            // Dark Mode Toggle
            Semantics(
              identifier: 'profile_dark_mode_toggle',
              child: SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Enable dark theme'),
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() => _darkModeEnabled = value);
                },
              ),
            ),

            // Language Dropdown
            Semantics(
              identifier: 'profile_language_dropdown',
              child: ListTile(
                title: const Text('Language'),
                subtitle: Text(_selectedLanguage),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(context),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Semantics(
              identifier: 'profile_edit_button',
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit profile tapped')),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
            ),
            const SizedBox(height: 12),

            Semantics(
              identifier: 'profile_save_button',
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings saved!')),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Settings'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Semantics(
              identifier: 'profile_logout_button',
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Português', 'Español', 'Deutsch'].map((lang) {
            return Semantics(
              identifier: 'profile_language_option_${lang.toLowerCase()}',
              child: ListTile(
                title: Text(lang),
                leading: Radio<String>(
                  value: lang,
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    setState(() => _selectedLanguage = value!);
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  setState(() => _selectedLanguage = lang);
                  Navigator.pop(context);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
