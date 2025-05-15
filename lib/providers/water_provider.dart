import 'package:flutter/material.dart';

class IntakeData {
  int totalIntakeMl;
  int goalMl;
  IntakeData({required this.totalIntakeMl, required this.goalMl});
}

class WaterProvider with ChangeNotifier {
  IntakeData? intakeData;
  bool loading = false;

  // Initialize or load intake
  Future<void> loadIntake(String userId) async {
    loading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    // If intakeData is null, create default, else keep existing
    intakeData ??= IntakeData(totalIntakeMl: 0, goalMl: 2500);

    loading = false;
    notifyListeners();
  }

  // Add water intake
  Future<void> addWater(String userId, int amount) async {
    if (intakeData != null) {
      intakeData!.totalIntakeMl += amount;
      notifyListeners();

      if (intakeData!.totalIntakeMl >= intakeData!.goalMl) {
        debugPrint(
          '🎯 Goal met: ${intakeData!.totalIntakeMl} / ${intakeData!.goalMl}',
        );
      }
    }
  }

  // Set or update water goal
  void setGoal(int goalMl) {
    if (intakeData == null) {
      intakeData = IntakeData(totalIntakeMl: 0, goalMl: goalMl);
    } else {
      intakeData!.goalMl = goalMl;
    }
    notifyListeners();
  }
}
