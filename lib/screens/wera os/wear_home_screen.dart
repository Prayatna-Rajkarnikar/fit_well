import 'package:fit_well/providers/water_provider.dart';
import 'package:fit_well/screens/wera%20os/wear_water_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear_plus/wear_plus.dart';

import '../../providers/theme_provider.dart';
import '../../providers/watch_provider.dart';
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
    Provider.of<WatchProvider>(context, listen: false);
    Provider.of<WatchProvider>(context, listen: false).loadUserData();
    Provider.of<WaterProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      builder:
          (context, mode, child) => Scaffold(
            appBar: AppBar(
              toolbarHeight: 36,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        title: Text(
                          'Calories Burned',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        trailing: Icon(
                          Icons.local_fire_department_rounded,
                          size: 20.0,
                        ),
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
                      child: ListTile(
                        title: Text(
                          'Water Log',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        trailing: Icon(Icons.water_drop_rounded, size: 20.0),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WearWaterScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(
                          'Timer',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        trailing: Icon(Icons.alarm_rounded, size: 20.0),
                      ),
                    ),
                    SizedBox(height: 28.0),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
