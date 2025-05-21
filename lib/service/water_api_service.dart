import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class WaterApiService {
  String baseUrl = AppConfig.baseUrl;

  Future<void> setWaterGoal(int waterGoalMl) async {
    final url = Uri.parse("$baseUrl/water/set-goal");

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'token=$token',
        },
        body: jsonEncode({"waterGoalMl": waterGoalMl}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to set water goal: ${response.body}");
      }

      debugPrint("Water goal set successfully: ${response.body}");
    } catch (e) {
      throw Exception("Error setting water goal: $e");
    }
  }

  Future<void> addWaterIntake(int amountMl) async {
    final url = Uri.parse("$baseUrl/water/add");

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'token=$token',
        },
        body: jsonEncode({"amountMl": amountMl}),
      );

      if (response.statusCode != 201) {
        throw Exception("Failed to add water intake: ${response.body}");
      }

      debugPrint("Water intake added: ${response.body}");
    } catch (e) {
      throw Exception("Error adding water intake: $e");
    }
  }

  Future<Map<String, dynamic>> getDailyIntake() async {
    final url = Uri.parse("$baseUrl/water/daily");

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'token=$token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch daily intake: ${response.body}");
      }

      final data = jsonDecode(response.body);
      debugPrint("Daily intake data: ${response.body}");
      return {
        'totalIntakeMl': data['totalIntakeMl'] ?? 0,
        'goalMl': data['goalMl'] ?? 2000,
      };
    } catch (e) {
      throw Exception("Error fetching daily intake: $e");
    }
  }

  Future<void> resetWaterIntake() async {
    final url = Uri.parse("$baseUrl/water/reset");

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'token=$token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to reset water intake: ${response.body}");
      }

      debugPrint("Water intake reset successfully: ${response.body}");
    } catch (e) {
      throw Exception("Error resetting water intake: $e");
    }
  }

}