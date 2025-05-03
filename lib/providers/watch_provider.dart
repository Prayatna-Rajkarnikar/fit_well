import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class WatchProvider with ChangeNotifier {
  final WatchConnectivity _watch = WatchConnectivity();
  final Map<String, dynamic> _userData = {};

  Map<String, dynamic> get userData => _userData;

  WatchProvider() {
    _watch.messageStream.listen((message) async {
      debugPrint('Received message: $message');

      if (message.containsKey('token')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', message['token']);
      } else {
        debugPrint('No token found in message.');
      }

      // _userData.clear();
      _userData.addAll(message);
      notifyListeners();
    });
  }

  void updateWeight(double newWeight) async {
    _userData['weightKg'] = newWeight;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weightKg', newWeight);
    
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? savedWeight = prefs.getDouble('weightKg');
    if (savedWeight != null) {
      userData['weightKg'] = savedWeight;
      notifyListeners();
    }
  }

}
