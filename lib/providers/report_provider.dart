import 'package:flutter/material.dart';

import '../service/report_service.dart';

class ReportProvider with ChangeNotifier {
  List<dynamic> _calorieLogs = [];
  List<dynamic> _waterLogs = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get calorieLogs => _calorieLogs;
  List<dynamic> get waterLogs => _waterLogs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchReport() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final report = await ReportService().getAllLogs();
      _calorieLogs = report.calorieLogs;
      _waterLogs = report.waterLogs;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
