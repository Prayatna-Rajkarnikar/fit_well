class ActivityModel {
  final String activity;

  ActivityModel({required this.activity});

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    if (json['activity'] == null) {
      throw Exception("Invalid activity received from backend: $json");
    }
    return ActivityModel(activity: json["activity"] as String);
  }
}
