import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/water_provider.dart';
import 'water_goal_screen.dart';
import '../../service/notification_service.dart';

class WaterHomeScreen extends StatefulWidget {
  const WaterHomeScreen({Key? key}) : super(key: key);

  @override
  _WaterHomeScreenState createState() => _WaterHomeScreenState();
}

class _WaterHomeScreenState extends State<WaterHomeScreen> {
  bool _isLoading = true;
  double _sliderValue = 250;
  final _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.init();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<WaterProvider>(
        context,
        listen: false,
      ).fetchDailyIntake();

      final provider = Provider.of<WaterProvider>(context, listen: false);
      await _notificationService.showWaterGoalNotification(
        provider.currentIntake,
        provider.waterGoal,
      );
    } catch (e) {
      _showSnackBar(success: false, message: 'Failed to load water data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar({required bool success, required String message}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(success ? Icons.check_circle : Icons.error, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      elevation: 6,
      action: SnackBarAction(
        label: 'DISMISS',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _addWater(double amount) async {
    final provider = Provider.of<WaterProvider>(context, listen: false);
    final int newIntake = provider.currentIntake + amount.toInt();

    if (newIntake > provider.waterGoal) {
      _showSnackBar(
        success: false,
        message: 'Cannot add water beyond the goal (${provider.waterGoal} ml).',
      );
      return;
    }

    try {
      await provider.addWaterIntake(amount.toInt());

      await _notificationService.showWaterGoalNotification(
        provider.currentIntake,
        provider.waterGoal,
      );

      _showSnackBar(success: true, message: 'Added ${amount.toInt()} ml');
    } catch (e) {
      _showSnackBar(success: false, message: 'Failed to add water: $e');
    }
  }

  Future<void> _resetWater() async {
    try {
      await Provider.of<WaterProvider>(
        context,
        listen: false,
      ).resetWaterIntake();
      _showSnackBar(success: true, message: 'Water intake reset to 0 ml');
    } catch (e) {
      _showSnackBar(
        success: false,
        message: 'Failed to reset water intake: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Water Tracker',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          TextButton(
            child: Text(
              'Set Goal',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.myGreen),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WaterGoalScreen()),
              );
              await _loadData(); // Refresh after goal change
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Consumer<WaterProvider>(
                builder: (context, provider, child) {
                  final progress =
                      provider.waterGoal > 0
                          ? provider.currentIntake / provider.waterGoal
                          : 0.0;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Today\'s Water Intake',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 20),
                        CircularProgressIndicator(
                          value: progress > 1 ? 1.0 : progress,
                          strokeWidth: 10,
                          backgroundColor: AppColors.myLightGray,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progress >= 1
                                ? AppColors.myGreen
                                : AppColors.myGray,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${provider.currentIntake} / ${provider.waterGoal} ml',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Select Amount to Add: ${_sliderValue.toInt()} ml',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Slider(
                          activeColor: AppColors.myGreen,
                          value: _sliderValue,
                          min: 50,
                          max: 1000,
                          divisions: 19,
                          label: '${_sliderValue.toInt()} ml',
                          onChanged: (value) {
                            setState(() {
                              _sliderValue = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _addWater(_sliderValue),
                          child: const Text('Add Water'),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: _resetWater,
                          child: Text(
                            'Reset Intake',
                            style: TextStyle(
                              color: AppColors.myGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
