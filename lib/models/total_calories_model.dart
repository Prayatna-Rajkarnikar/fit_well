class TotalCaloriesModel {
  final double totalCaloriesBurned;

  TotalCaloriesModel({required this.totalCaloriesBurned});

  factory TotalCaloriesModel.fromJson(Map<String, dynamic> json) {
    return TotalCaloriesModel(
      totalCaloriesBurned: (json['totalCaloriesBurned'] as num).toDouble(),
    );
  }
}
