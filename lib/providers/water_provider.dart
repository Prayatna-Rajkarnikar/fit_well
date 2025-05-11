import 'package:fit_well/service/notification_service.dart';
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
    // First, check the current intake data
    final lastIntake = _intakeData?.lastIntakeTime;

    // Define a cooldown period (e.g., 1 hour)
    final bool shouldNotify =
        lastIntake == null ||
        DateTime.now().difference(lastIntake) > const Duration(hours: 1);

    final success = await apiService.addIntake(userId, liters);
    if (success) {
      await loadIntake(userId); // refresh data

      // Trigger reminder only if enough time has passed
      if (liters >= 5.0 && shouldNotify) {
        await NotificationService.scheduleWaterReminder();
      }
    }
  }
}
