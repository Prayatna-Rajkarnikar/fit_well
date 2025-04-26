import 'package:fit_well/models/total_calories_model.dart';
import 'package:fit_well/service/calorie_service.dart';
import 'package:flutter/cupertino.dart';

class CalorieProvider with ChangeNotifier {
  final CalorieService _calorieService = CalorieService();
  TotalCaloriesModel? _totalCalorieData;

  TotalCaloriesModel? get totalCalorieData => _totalCalorieData;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchCaloriesBurned() async {
    _isLoading = true;
    notifyListeners();

    try {
      _totalCalorieData = await _calorieService.getCaloriesBurned();
    } catch (e) {
      debugPrint("Error fetching calories: $e");
      throw Exception("Error fetching total calories: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
