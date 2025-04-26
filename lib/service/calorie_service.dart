import 'dart:convert';
import 'package:fit_well/models/total_calories_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import 'package:http/http.dart' as http;

class CalorieService {
  String baseUrl = AppConfig.baseUrl;

  Future<TotalCaloriesModel> getCaloriesBurned() async {
    final url = Uri.parse("$baseUrl/fitness/getTotalCaloriesBurned");

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      debugPrint('Token fetched inside CalorieService: $token');

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Cookie': 'token=$token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final totalCalories = TotalCaloriesModel.fromJson(data);
        debugPrint("Total calories from service: ${response.body}");
        return totalCalories;
      } else {
        throw Exception(
          'Failed to load calories. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception("Error fetching total calories: $e");
    }
  }
}
