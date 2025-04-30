class ActivityModel {
  final String activity;

  ActivityModel({required this.activity});

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(activity: json["activity"]);
  }
}
