class WaterIntakeModel {
  final double totalIntakeLiters;
  final double goalLiters;

  WaterIntakeModel({required this.totalIntakeLiters, required this.goalLiters});

  factory WaterIntakeModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeModel(
      totalIntakeLiters: (json['totalIntakeLiters'] ?? 0).toDouble(),
      goalLiters: (json['goalLiters'] ?? 2).toDouble(),
    );
  }
}
