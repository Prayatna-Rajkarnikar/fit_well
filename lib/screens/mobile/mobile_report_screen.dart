import 'package:fit_well/providers/theme_provider.dart';
import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/report_provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool showWaterLogs = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).fetchReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
              selectedColor: AppColors.myWhite,
              fillColor: AppColors.myGreen,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Water Logs', style: Theme.of(context).textTheme.bodyMedium,),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Calorie Logs', style: Theme.of(context).textTheme.bodyMedium),
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
                  color: themeProvider.isDarkMode? AppColors.myGray : AppColors.myLightGray,

                  margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(showWaterLogs
                        ? 'Amount: ${log['amountLiters'] ?? '-'} liters'
                        : 'Calories Burned: ${log['caloriesBurned'] ?? '-'}', style: Theme.of(context).textTheme.bodyMedium,),
                    subtitle: Text(
                      showWaterLogs
                          ? 'Date: ${DateTime.parse(log['date']).toLocal().toString().split(' ')[0]}'
                          : 'Date: ${DateTime.parse(log['createdAt']).toLocal().toString().split(' ')[0]}',
                      style: Theme.of(context).textTheme.bodyMedium,
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
