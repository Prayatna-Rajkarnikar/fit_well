import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear_plus/wear_plus.dart';

import '../providers/theme_provider.dart';
import 'wear_calorie_screen.dart';

class WearHomeScreen extends StatefulWidget {
  const WearHomeScreen({super.key});

  @override
  State<WearHomeScreen> createState() => _WearHomeScreenState();
}

class _WearHomeScreenState extends State<WearHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Provider.of<WatchProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      builder:
          (context, mode, child) => Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fit well',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        final icon =
                            themeProvider.isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode;
                        return IconButton(
                          icon: Icon(icon, size: 16),
                          onPressed: () {
                            themeProvider.toggleTheme(
                              !themeProvider.isDarkMode,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: const Text('Calories Burned'),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WearCalorieScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    Card(
                      child: const ListTile(
                        title: Text('Water Log'),
                        subtitle: Text('Tap to view or update water intake'),
                      ),
                    ),
                    Card(
                      child: const ListTile(
                        title: Text('Timer'),
                        subtitle: Text('Start or view your timer'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
