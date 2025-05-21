import 'dart:convert';
import 'package:fit_well/config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  String baseUrl = AppConfig.baseUrl;

  Future<UserModel> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint("Login response: ${response.body}");

      String token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      debugPrint('Token stored: $token');

      return UserModel.fromJson(data['user']);
    } else {
      String errorMessage = 'Login failed';
      try {
        final errorData = jsonDecode(response.body);
        if (errorData['error'] != null) {
          errorMessage = errorData['error'];
        }
      } catch (_) {}

      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> registerUser(
    String name,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return {'success': true, 'message': 'Registration successful!'};
    } else {
      String errorMsg = 'Registration failed';
      try {
        final data = jsonDecode(response.body);
        if (data['error'] != null) {
          errorMsg = data['error'];
        }
      } catch (_) {
        throw Exception('Register failed');
      }

      return {'success': false, 'message': errorMsg};
    }
  }
}
