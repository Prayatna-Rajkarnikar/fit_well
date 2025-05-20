import 'dart:async';
import 'package:flutter/foundation.dart';
import '../service/water_api_service.dart';
import '../service/notification_service.dart';

class WaterProvider extends ChangeNotifier {
  final WaterApiService _apiService = WaterApiService();
  final NotificationService _notificationService = NotificationService();

  int _waterGoal = 2000; // Default value
  int _currentIntake = 0;

  Timer? _reminderTimer;

  int get waterGoal => _waterGoal;
  int get currentIntake => _currentIntake;

  WaterProvider() {
    _notificationService.init();
    _startReminderTimer();
  }

  void _startReminderTimer() {
    // Cancel any existing timer
    _reminderTimer?.cancel();

    // Start a new timer for 1 minute
    _reminderTimer = Timer(const Duration(minutes: 1), () {
      // If no water intake in the last minute, show reminder notification
      if (_currentIntake == 0) {
        _notificationService.showHydrationReminder();
      }
    });
  }

  Future<void> setWaterGoal(int waterGoalMl) async {
    try {
      await _apiService.setWaterGoal(waterGoalMl);
      _waterGoal = waterGoalMl;

      // Reset intake and restart timer
      _currentIntake = 0;
      notifyListeners();
      _startReminderTimer();
    } catch (e) {
      debugPrint("Provider Error - setWaterGoal: $e");
      rethrow;
    }
  }

  Future<void> addWaterIntake(int amountMl) async {
    try {
      _currentIntake += amountMl;
      notifyListeners();

      // Reset reminder timer because user just added water intake
      _startReminderTimer();

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

      _startReminderTimer();
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

      _startReminderTimer();
    } catch (e) {
      debugPrint("Provider Error - resetWaterIntake: $e");
      rethrow;
    }
  }

  @override
  void dispose() {
    _reminderTimer?.cancel();
    super.dispose();
  }
}
