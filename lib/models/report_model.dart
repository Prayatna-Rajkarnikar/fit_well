class ReportModel {
  final List<dynamic> waterLogs;
  final List<dynamic> calorieLogs;

  ReportModel({required this.waterLogs, required this.calorieLogs});

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      waterLogs: json['waterLogs'] ?? [],
      calorieLogs: json['calorieLogs'] ?? [],
    );
  }
}