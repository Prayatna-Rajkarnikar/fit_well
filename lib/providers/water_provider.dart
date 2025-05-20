import 'package:flutter/foundation.dart';
import '../service/water_api_service.dart';

class WaterProvider extends ChangeNotifier {
  final WaterApiService _apiService = WaterApiService();

  int _waterGoal = 2000; // Default value
  int _currentIntake = 0;

  int get waterGoal => _waterGoal;
  int get currentIntake => _currentIntake;


  Future<void> setWaterGoal(int waterGoalMl) async {
    try {
      await _apiService.setWaterGoal(waterGoalMl);
      _waterGoal = waterGoalMl;

      // Reset intake when new goal is set
      _currentIntake = 0;

      notifyListeners();
    } catch (e) {
      debugPrint("Provider Error - setWaterGoal: $e");
      rethrow;
    }
  }

  Future<void> addWaterIntake(int amountMl) async {
    try {
      _currentIntake += amountMl;
      notifyListeners();

      await _apiService.addWaterIntake(amountMl);
      await fetchDailyIntake();
    } catch (e) {
      _currentIntake -= amountMl;
      notifyListeners();
      debugPrint("Provider Error - addWaterIntake: $e");
      rethrow;
    }
  }

  Future<void> fetchDailyIntake() async {
    try {
      final data = await _apiService.getDailyIntake();
      _currentIntake = data['totalIntakeMl'] ?? 0;
      _waterGoal = data['goalMl'] ?? 2000;
      notifyListeners();
    } catch (e) {
      debugPrint("Provider Error - fetchDailyIntake: $e");
      rethrow;
    }
  }
  Future<void> resetWaterIntake() async {
    try {
      await _apiService.resetWaterIntake();
      _currentIntake = 0;
      notifyListeners();
    } catch (e) {
      debugPrint("Provider Error - resetWaterIntake: $e");
      rethrow;
    }
  }

}
