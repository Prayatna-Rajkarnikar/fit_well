import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../service/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  UserModel? _user;

  bool get isLoading => _isLoading;
  UserModel? get user => _user;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loggedInUser = await _authService.loginUser(email, password);
      _user = loggedInUser;
      await _sendUserDataToWatch(_user!);
    } catch (e) {
      debugPrint("Login error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.registerUser(name, email, password);
    } catch (e) {
      debugPrint("Register error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _sendUserDataToWatch(UserModel user) async {
    final watch = WatchConnectivity();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final userData = {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'weightKg': user.weightKg,
        'token': token
      };
      await watch.sendMessage(userData);
    } catch (e) {
      debugPrint('Failed to send to watch: $e');
    }
  }
}
