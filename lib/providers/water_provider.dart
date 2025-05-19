import 'package:fit_well/service/water_api_service.dart';
import 'package:flutter/foundation.dart';

class WaterProvider extends ChangeNotifier {
  final String userId;
  int waterGoal = 2000;
  int currentIntake = 0;
  final WaterApiService api = WaterApiService();

  WaterProvider({required this.userId});

  Future<void> fetchDailyIntake() async {
    try {
      final data = await api.getDailyIntake(userId);
      waterGoal = data['waterGoal'] ?? 2000;
      currentIntake = data['currentIntake'] ?? 0;
      notifyListeners();
    } catch (e) {
      // handle error or set defaults
      debugPrint("fetchDailyIntake error: $e");
    }
  }

  Future<void> setWaterGoal(int goal) async {
    await api.setWaterGoal(goal);
    waterGoal = goal;
    notifyListeners();
  }

  Future<void> addWaterIntake(int amount) async {
    await api.addWaterIntake(amount);
    currentIntake += amount;
    notifyListeners();
  }
}
