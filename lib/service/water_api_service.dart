import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/water_intake_model.dart';

class WaterApiService {
  final String baseUrl;

  WaterApiService(this.baseUrl);

  Future<WaterIntakeModel?> fetchDailyIntake(String userId) async {
    final url = Uri.parse('$baseUrl/api/water/daily?userId=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WaterIntakeModel.fromJson(json.decode(response.body));
    }
    return null;
  }

  Future<bool> addIntake(String userId, int amountMl) async {
    final url = Uri.parse('$baseUrl/api/water/add');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"userId": userId, "amountMl": amountMl}),
    );
    return response.statusCode == 201;
  }
}
