import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/report_provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool showWaterLogs = true; // toggle state

  @override
  void initState() {
    super.initState();
    // Fetch logs on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).fetchReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);

    if (reportProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (reportProvider.error != null) {
      return Center(child: Text('Error: ${reportProvider.error}'));
    }

    // Select which logs to show based on toggle
    final logs = showWaterLogs
        ? reportProvider.waterLogs
        : reportProvider.calorieLogs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Report'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Toggle buttons to choose logs
          Padding(
            padding: const EdgeInsets.all(16),
            child: ToggleButtons(
              isSelected: [showWaterLogs, !showWaterLogs],
              onPressed: (index) {
                setState(() {
                  showWaterLogs = (index == 0);
                });
              },
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: Theme.of(context).primaryColor,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Water Logs'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Calorie Logs'),
                ),
              ],
            ),
          ),

          Expanded(
            child: logs.isEmpty
                ? Center(child: Text('No ${showWaterLogs ? 'water' : 'calorie'} logs available'))
                : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Card(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(showWaterLogs
                        ? 'Amount: ${log['amountLiters'] ?? '-'} liters'
                        : 'Calories Burned: ${log['caloriesBurned'] ?? '-'}'),
                    subtitle: Text(
                      showWaterLogs
                          ? 'Date: ${DateTime.parse(log['date']).toLocal().toString().split(' ')[0]}'
                          : 'Date: ${DateTime.parse(log['createdAt']).toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
