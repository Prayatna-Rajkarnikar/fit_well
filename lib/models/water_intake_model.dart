class WaterIntakeModel {
  final double totalIntakeLiters;
  final double goalLiters;

  final DateTime? lastIntakeTime;
  WaterIntakeModel({
    required this.totalIntakeLiters,
    required this.goalLiters,
    this.lastIntakeTime,
  });

  factory WaterIntakeModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeModel(
      totalIntakeLiters: (json['totalIntakeLiters'] ?? 0).toDouble(),
      goalLiters: (json['goalLiters'] ?? 2).toDouble(),
      lastIntakeTime:
          json['lastIntakeTime'] != null
              ? DateTime.parse(json['lastIntakeTime'])
              : null,
    );
  }
}
