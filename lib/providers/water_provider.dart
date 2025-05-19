import 'package:flutter/foundation.dart';

import '../service/water_api_service.dart';

class WaterProvider extends ChangeNotifier {
  final WaterApiService _apiService = WaterApiService();

  int _waterGoal = 0;
  int _currentIntake = 0;

  int get waterGoal => _waterGoal;
  int get currentIntake => _currentIntake;

  Future<void> setWaterGoal(int waterGoalMl) async {
    try {
      await _apiService.setWaterGoal(waterGoalMl);
      _waterGoal = waterGoalMl;
      notifyListeners();
    } catch (e) {
      debugPrint("Provider Error - setWaterGoal: $e");
      rethrow;
    }
  }

 Future<void> addWaterIntake(int amountMl) async {
    try {
      await _apiService.addWaterIntake(amountMl);
      await fetchDailyIntake();
    } catch (e) {
      debugPrint("Provider Error - addWaterIntake: $e");
      rethrow;
    }
  }

  Future<void> fetchDailyIntake() async {
    try {
      final data = await _apiService.getDailyIntake();
      _currentIntake = data['totalIntake'] ?? 0;
      _waterGoal = data['waterGoal'] ?? 0;
      notifyListeners();
    } catch (e) {
      debugPrint("Provider Error - fetchDailyIntake: $e");
      rethrow;
    }
  }
}
