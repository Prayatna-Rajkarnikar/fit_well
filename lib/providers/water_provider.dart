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
      notifyListeners();
    } catch (e) {
      debugPrint("Provider Error - setWaterGoal: $e");
      rethrow;
    }
  }

  Future<void> addWaterIntake(int amountMl) async {
    try {
      // Update local state immediately for better UX
      _currentIntake += amountMl;
      notifyListeners();

      // Then sync with server
      await _apiService.addWaterIntake(amountMl);

      // Finally, get the latest state from server
      await fetchDailyIntake();
    } catch (e) {
      // Rollback if error occurs
      _currentIntake -= amountMl;
      notifyListeners();
      debugPrint("Provider Error - addWaterIntake: $e");
      rethrow;
    }
  }

  Future<void> fetchDailyIntake() async {
    try {
      final data = await _apiService.getDailyIntake();
      _currentIntake = data['totalIntakeMl'] ?? 0; // Match your API response keys
      _waterGoal = data['goalMl'] ?? 2000;
      notifyListeners();
    } catch (e) {
      debugPrint("Provider Error - fetchDailyIntake: $e");
      rethrow;
    }
  }
}