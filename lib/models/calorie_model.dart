
class CalorieModel {
  final String activity;
  final int durationHours;
  final double met;
  final double caloriesBurned;

  CalorieModel({
    required this.activity,
    required this.durationHours,
    required this.met,
    required this.caloriesBurned,
  });

  factory CalorieModel.fromJson(Map<String, dynamic> json) {
    return CalorieModel(
      activity: json["activity"],
      durationHours: json["durationHours"],
      met: json["MET"].toDouble(),
      caloriesBurned: json["caloriesBurned"].toDouble(),
    );
  }
}
