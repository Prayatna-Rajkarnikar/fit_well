import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  final String _baseUrl =
      'http://100.64.205.1:3000'; // Replace with your backend IP

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('$_baseUrl/auth/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        debugPrint('✅ Registered successfully');
      } else {
        debugPrint('❌ Registration failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('$_baseUrl/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('✅ Login success. Token: ${data['token']}');

        // You can store the token with SharedPreferences if needed
      } else {
        debugPrint('❌ Login failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
