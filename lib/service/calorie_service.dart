import 'dart:convert';
import 'package:fit_well/models/activityModel.dart';
import 'package:fit_well/models/calorie_model.dart';
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

  Future<CalorieModel> addCalorie(String activity, int durationHours) async {
    final url = Uri.parse("$baseUrl/fitness/calculateCalorie");

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if(token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.post(
          url,
          headers: {
            'Content-type': 'application/json',
            'Cookie': 'token=$token'},
          body: jsonEncode(
          {
              "activity": activity,
            "durationHours": durationHours
          })
      );

      if(response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("response: ${response.body}");
        final calorie = CalorieModel.fromJson(data['record']);
        return calorie;
      } else {
        throw Exception("Failed to add calories");
      }
    } catch(e) {
      throw Exception('$e');
    }
  }

Future<List<ActivityModel>> getActivities() async{
    final url = Uri.parse("$baseUrl/met/getAllActivity");
    try {
      final response  = await http.get(url);

      if(response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("response: ${response.body}");
        final activitiesJson = data['activities'] as List;
        final activities = activitiesJson.map((json)=> ActivityModel.fromJson(json)).toList();
        return activities;
      } else {
        throw Exception("Failed to get all the activity");
      }
    } catch (e) {
      throw Exception("Failed to get activity from backend $e");
    }
}

}

