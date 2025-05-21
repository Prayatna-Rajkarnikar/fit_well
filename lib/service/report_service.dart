import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../models/report_model.dart';

class ReportService {
  String baseUrl = AppConfig.baseUrl;

  Future<ReportModel> getAllLogs() async {
    final url = Uri.parse("$baseUrl/auth/report");

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
          'Cookie': 'token=$token'        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("Report data: ${response.body}");
        return ReportModel.fromJson(data);
      } else {
        debugPrint("Report data: ${response.body}");

        throw Exception('Failed to fetch logs');
      }
    } catch (e) {

      throw Exception('Error fetching logs: $e');
    }
  }
}