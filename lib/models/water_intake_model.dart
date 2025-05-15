class WaterIntakeModel {
  final int totalIntakeMl;
  final int goalMl;
  final DateTime? lastIntakeTime;

  WaterIntakeModel({
    required this.totalIntakeMl,
    required this.goalMl,
    this.lastIntakeTime,
  });

  factory WaterIntakeModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeModel(
      totalIntakeMl: json['totalIntakeMl'] ?? 0,
      goalMl: json['goalMl'] ?? 2000,
      lastIntakeTime:
          json['lastIntakeTime'] != null
              ? DateTime.parse(json['lastIntakeTime'])
              : null,
    );
  }
}
