import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/water_provider.dart';
import 'package:fit_well/screens/mobile/water_goal_screen.dart';

class WaterHomeScreen extends StatefulWidget {
  const WaterHomeScreen({Key? key}) : super(key: key);

  @override
  _WaterHomeScreenState createState() => _WaterHomeScreenState();
}

class _WaterHomeScreenState extends State<WaterHomeScreen> {
  bool _isLoading = true;
  double _sliderValue = 250;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<WaterProvider>(
        context,
        listen: false,
      ).fetchDailyIntake();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load water data: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addWater(double amount) async {
    try {
      await Provider.of<WaterProvider>(
        context,
        listen: false,
      ).addWaterIntake(amount.toInt());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Added ${amount.toInt()} ml')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add water: $e')));
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
                MaterialPageRoute(
                  builder: (context) => const WaterGoalScreen(),
                ),
              );
              await _loadData();
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
                            progress >= 1 ? AppColors.myGreen: AppColors.myGray,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${provider.currentIntake}/ ${provider.waterGoal}ml',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Select Amount to Add: ${_sliderValue.toInt()} ml',
                                           style: Theme.of(context).textTheme.bodyMedium

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
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
