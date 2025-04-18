import 'package:flutter/material.dart';
import 'package:wear_plus/wear_plus.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class WearHomeScreen extends StatefulWidget {
  const WearHomeScreen({super.key});

  @override
  State<WearHomeScreen> createState() => _WearHomeScreenState();
}

class _WearHomeScreenState extends State<WearHomeScreen> {
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
          ),
    );
  }
}
