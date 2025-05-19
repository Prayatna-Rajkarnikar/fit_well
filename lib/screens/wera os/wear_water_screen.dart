import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/water_provider.dart';
import '../mobile/water_goal_screen.dart';

class WearWaterScreen extends StatefulWidget {
  const WearWaterScreen({Key? key}) : super(key: key);

  @override
  State<WearWaterScreen> createState() => _WaterHomeScreenState();
}

class _WaterHomeScreenState extends State<WearWaterScreen> {
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
        SnackBar(content: Text('Failed to load water data: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addWater(double amount) async {
    try {
      await Provider.of<WaterProvider>(context, listen: false).addWaterIntake(amount.toInt());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added ${amount.toInt()} ml')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add water: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<WaterProvider>(
        builder: (context, provider, _) {
          final progress = provider.waterGoal > 0
              ? provider.currentIntake / provider.waterGoal
              : 0.0;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${provider.currentIntake} / ${provider.waterGoal} ml',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 6,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 1 ? Colors.green : Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${_sliderValue.toInt()} ml',
                  style: const TextStyle(fontSize: 12),
                ),
                Slider(
                  value: _sliderValue,
                  min: 50,
                  max: 1000,
                  divisions: 19,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                ),
                const SizedBox(height: 6),
                ElevatedButton(
                  onPressed: () => _addWater(_sliderValue),
                  child: const Text('Add'),
                ),
                const SizedBox(height: 6),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WaterGoalScreen()),
                    );
                    await _loadData();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
