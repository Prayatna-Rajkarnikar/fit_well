import 'package:fit_well/service/water_api_service.dart';
import 'package:flutter/material.dart';
import '../models/water_intake_model.dart';

class WaterProvider with ChangeNotifier {
  final WaterApiService apiService;
  WaterIntakeModel? _intakeData;
  bool _loading = false;

  WaterProvider({required this.apiService});

  WaterIntakeModel? get intakeData => _intakeData;
  bool get loading => _loading;

  Future<void> loadIntake(String userId) async {
    _loading = true;
    notifyListeners();
    _intakeData = await apiService.fetchDailyIntake(userId);
    _loading = false;
    notifyListeners();
  }

  Future<void> addWater(String userId, double liters) async {
    final success = await apiService.addIntake(userId, liters);
    if (success) {
      await loadIntake(userId);
    }
  }
}
