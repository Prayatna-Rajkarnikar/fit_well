import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear_plus/wear_plus.dart';
import '../../providers/water_provider.dart';
import '../mobile/water_goal_screen.dart';

class WearWaterScreen extends StatefulWidget {
  const WearWaterScreen({Key? key}) : super(key: key);

  @override
  State<WearWaterScreen> createState() => _WearWaterScreenState();
}

class _WearWaterScreenState extends State<WearWaterScreen> {
  double _sliderValue = 250;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<WaterProvider>(context, listen: false).fetchDailyIntake();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Load failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addWater(double amount) async {
    final provider = Provider.of<WaterProvider>(context, listen: false);
    final newTotal = provider.currentIntake + amount.toInt();

    if (newTotal > provider.waterGoal) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Limit Reached'),
          content: Text('${provider.waterGoal} ml goal exceeded.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      await provider.addWaterIntake(amount.toInt());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added ${amount.toInt()} ml')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _resetWater() async {
    try {
      await Provider.of<WaterProvider>(context, listen: false).resetWaterIntake();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Intake reset')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reset failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      builder: (context, shape, child) {
        return Scaffold(
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Consumer<WaterProvider>(
            builder: (context, provider, _) {
              final progress = provider.waterGoal > 0
                  ? provider.currentIntake / provider.waterGoal
                  : 0.0;

              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            strokeWidth: 5,
                            backgroundColor: Colors.grey[700],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress >= 1 ? AppColors.myGreen : AppColors.myGray,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${provider.currentIntake}/${provider.waterGoal} ml',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Add: ${_sliderValue.toInt()} ml',
                      style:Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Slider(
                    value: _sliderValue,
                    min: 50,
                    max: 1000,
                    divisions: 19,
                    activeColor: AppColors.myGreen,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () => _addWater(_sliderValue),
                      child: const Text('Add'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: _resetWater,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Reset'),
                    ),
                  ),
                  TextButton(
                    child: Text('Set Goal',style: Theme.of(context).textTheme.bodyMedium,),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WaterGoalScreen()),
                      );
                      await _loadData();
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
