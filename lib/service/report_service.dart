import 'dart:convert';
import 'package:fit_well/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/report_model.dart';

class ReportService {
  String baseUrl = AppConfig.baseUrl; // Replace with your actual backend URL

  Future<DailyReport> fetchDailyReport(String userId, String date) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/auth/report/$userId?date=$date');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DailyReport.fromJson(data);
    } else {
      throw Exception('Failed to load daily report: ${response.body}');
    }
  }
}
