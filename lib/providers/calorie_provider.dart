import 'package:fit_well/models/activityModel.dart';
import 'package:fit_well/models/calorie_model.dart';
import 'package:fit_well/models/total_calories_model.dart';
import 'package:fit_well/service/calorie_service.dart';
import 'package:flutter/cupertino.dart';

class CalorieProvider with ChangeNotifier {
  final CalorieService _calorieService = CalorieService();
  TotalCaloriesModel? _totalCalorieData;
  CalorieModel? _calorieData;
  List<ActivityModel>? _activityModel;

  TotalCaloriesModel? get totalCalorieData => _totalCalorieData;
  CalorieModel? get calorieData => _calorieData;
  List<ActivityModel>? get activity => _activityModel;
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

  Future<void> addCalories(String activity, int durationHours) async {
    _isLoading = true;
    notifyListeners();

    try {
      _calorieData = await _calorieService.addCalorie(activity, durationHours);

    } catch(e) {
      throw Exception("Error adding calorie: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getAllActivities() async {
    try {
      _activityModel = await _calorieService.getActivities();
      notifyListeners();
    } catch(e) {
      throw Exception("Error getting all activity");
    }
  }
}
