import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  bool soundEnabled = true;
  bool vibrationEnabled = true;
  bool enterToSend = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  // Load saved settings
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      notificationsEnabled =
          prefs.getBool('notificationsEnabled') ?? true;

      darkModeEnabled =
          prefs.getBool('darkModeEnabled') ?? false;

      soundEnabled =
          prefs.getBool('soundEnabled') ?? true;

      vibrationEnabled =
          prefs.getBool('vibrationEnabled') ?? true;

      enterToSend =
          prefs.getBool('enterToSend') ?? false;
    });
  }

  // Save a setting
  Future<void> saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void showPrivacyOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                leading: Icon(Icons.visibility),
                title: Text('Profile Visibility'),
                subtitle: Text('Who can see your profile'),
              ),
              const ListTile(
                leading: Icon(Icons.block),
                title: Text('Blocked Users'),
                subtitle: Text('Manage blocked contacts'),
              ),
              const ListTile(
                leading: Icon(Icons.security),
                title: Text('Security'),
                subtitle: Text('Manage account security'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void showAboutChatNest() {
    showAboutDialog(
      context: context,
      applicationName: 'ChatNest',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.chat_bubble),
      children: const [
        SizedBox(height: 10),
        Text(
          'ChatNest is a simple and friendly chat application.',
        ),
        SizedBox(height: 10),
        Text('Built with Flutter.'),
      ],
    );
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out'),
                  ),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        8,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        children: [

          sectionTitle('Preferences'),

          // Notifications
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text(
              'Receive message notifications',
            ),
            secondary: const Icon(
              Icons.notifications_outlined,
            ),
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });

              saveSetting(
                'notificationsEnabled',
                value,
              );
            },
          ),

          // Dark Mode
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text(
              'Use dark theme',
            ),
            secondary: const Icon(
              Icons.dark_mode_outlined,
            ),
            value: darkModeEnabled,
            onChanged: (value) {

              // Update the switch
              setState(() {
                darkModeEnabled = value;
              });

              // Change the whole app theme immediately
              darkModeNotifier.value = value;

              // Save the setting
              saveSetting(
                'darkModeEnabled',
                value,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value
                        ? 'Dark Mode enabled'
                        : 'Dark Mode disabled',
                  ),
                  duration: const Duration(
                    seconds: 1,
                  ),
                ),
              );
            },
          ),

          const Divider(),

          sectionTitle('Chat Settings'),

          // Message Sound
          SwitchListTile(
            title: const Text('Message Sound'),
            subtitle: const Text(
              'Play sound for messages',
            ),
            secondary: const Icon(
              Icons.volume_up_outlined,
            ),
            value: soundEnabled,
            onChanged: (value) {
              setState(() {
                soundEnabled = value;
              });

              saveSetting(
                'soundEnabled',
                value,
              );
            },
          ),

          // Vibration
          SwitchListTile(
            title: const Text('Vibration'),
            subtitle: const Text(
              'Vibrate on new messages',
            ),
            secondary: const Icon(
              Icons.vibration,
            ),
            value: vibrationEnabled,
            onChanged: (value) {
              setState(() {
                vibrationEnabled = value;
              });

              saveSetting(
                'vibrationEnabled',
                value,
              );
            },
          ),

          // Enter To Send
          SwitchListTile(
            title: const Text('Enter Key To Send'),
            subtitle: const Text(
              'Send message using keyboard enter',
            ),
            secondary: const Icon(
              Icons.keyboard_return,
            ),
            value: enterToSend,
            onChanged: (value) {
              setState(() {
                enterToSend = value;
              });

              saveSetting(
                'enterToSend',
                value,
              );
            },
          ),

          const Divider(),

          sectionTitle('Account & Privacy'),

          ListTile(
            leading: const Icon(
              Icons.lock_outline,
            ),
            title: const Text('Privacy'),
            subtitle: const Text(
              'Manage privacy settings',
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: showPrivacyOptions,
          ),

          ListTile(
            leading: const Icon(
              Icons.info_outline,
            ),
            title: const Text('About ChatNest'),
            subtitle: const Text(
              'Version 1.0.0',
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: showAboutChatNest,
          ),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onTap: showLogoutDialog,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}