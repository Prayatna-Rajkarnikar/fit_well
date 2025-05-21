import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  final WatchConnectivity _watch = WatchConnectivity();

  ThemeProvider() {
    loadTheme();
    _watch.messageStream.listen(_handleWatchMessage);
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) async {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isOn);

    await _watch.sendMessage({'isDarkMode': isOn});

    notifyListeners();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void _handleWatchMessage(Map<String, dynamic> message) async {
    if (message.containsKey('isDarkMode')) {
      final isDark = message['isDarkMode'] == true;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', isDark);

      notifyListeners();
    }
  }
}
