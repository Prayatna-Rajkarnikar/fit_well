import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = [
      {'icon': Icons.lock_outline, 'label': 'Change Password'},
      {'icon': Icons.account_circle_outlined, 'label': 'Profile Picture'},
      {'icon': Icons.share_outlined, 'label': 'Share'},
      {'icon': Icons.logout, 'label': 'Log Out'},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Setting', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Dark Mode Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Row(
                  children: [
                    Icon(Icons.dark_mode, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Dark Mode', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Switch(
                  value: true,
                  onChanged: null, // Add logic here later
                  activeColor: Colors.white,
                ),
              ],
            ),
            const Divider(color: Colors.white30),

            // Settings Options
            ...settings.map((item) => Column(
              children: [
                ListTile(
                  leading: Icon(item['icon'] as IconData, color: Colors.white),
                  title: Text(item['label'] as String, style: const TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                  onTap: () {}, // Add navigation logic here
                ),
                const Divider(color: Colors.white30),
              ],
            )),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white,
        currentIndex: 2,
        onTap: (index) {
          // Navigate between Home, Report, Profile
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
