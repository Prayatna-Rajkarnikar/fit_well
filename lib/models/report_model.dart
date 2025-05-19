class DailyReport {
  final double totalCaloriesBurned;
  final double totalWaterTakenMl;

  DailyReport({
    required this.totalCaloriesBurned,
    required this.totalWaterTakenMl,
  });

  factory DailyReport.fromJson(Map<String, dynamic> json) {
    return DailyReport(
      totalCaloriesBurned: (json['totalCaloriesBurned'] ?? 0).toDouble(),
      totalWaterTakenMl: (json['totalWaterTakenMl'] ?? 0).toDouble(),
    );
  }
}
