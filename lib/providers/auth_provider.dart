import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import '../service/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  UserModel? _user;

  String? get userId => _user?.id;

  bool get isLoading => _isLoading;

  UserModel? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loggedInUser = await _authService.loginUser(email, password);
      _user = loggedInUser;

      await _saveUserToPrefs(_user!);
      await _sendUserDataToWatch(_user!);

      _isLoading = false;
      notifyListeners();

      return {'success': true, 'message': 'Login successful!'};
    } catch (e) {
      debugPrint("Login error: $e");
      _isLoading = false;
      notifyListeners();

      return {
        'success': false,
        'message': 'Login failed. Invalid Credentials.',
      };
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknown error',
    };

    try {
      result = await _authService.registerUser(name, email, password);
    } catch (e) {
      debugPrint("Register error: $e");
      result = {'success': false, 'message': 'An error occurred'};
    }

    _isLoading = false;
    notifyListeners();

    return result;
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
        'token': token,
      };
      await watch.sendMessage(userData);
    } catch (e) {
      debugPrint('Failed to send to watch: $e');
    }
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final id = prefs.getString('id');
    final weightKg = prefs.getDouble('weightKg');

    if (name != null && email != null && id != null) {
      _user = UserModel(
        id: id,
        name: name,
        email: email,
        weightKg: weightKg ?? 0.0,
      );
      notifyListeners();
    }
  }

  Future<void> _saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', user.id);
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setDouble('weightKg', user.weightKg);
  }
}
