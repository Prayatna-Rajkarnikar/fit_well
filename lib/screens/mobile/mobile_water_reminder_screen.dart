import 'dart:async';
import 'package:fit_well/providers/water_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaterReminderScreen extends StatefulWidget {
  const WaterReminderScreen({Key? key}) : super(key: key);

  @override
  _WaterReminderScreenState createState() => _WaterReminderScreenState();
}

class _WaterReminderScreenState extends State<WaterReminderScreen> {
  Timer? notificationTimer;
  double selectedWaterAmount = 500;

  @override
  void initState() {
    super.initState();

    // Load water data on screen load
    Future.microtask(() {
      Provider.of<WaterProvider>(context, listen: false).fetchDailyIntake();
    });

    // Timer to remind user (e.g., every 1 min)
    notificationTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      final waterProvider = Provider.of<WaterProvider>(context, listen: false);
      final current = waterProvider.currentIntake;
      final goal = waterProvider.waterGoal;

      // TODO: Replace print with real notification
      debugPrint("Reminder check - $current / $goal");
    });
  }

  @override
  void dispose() {
    notificationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final waterProvider = Provider.of<WaterProvider>(context);
    final current = waterProvider.currentIntake;
    final goal = waterProvider.waterGoal;

    return Scaffold(
      appBar: AppBar(title: const Text('Water Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              '$current / $goal ml',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Select amount to add:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              '${selectedWaterAmount.toInt()} ml',
              style: const TextStyle(fontSize: 24),
            ),
            Slider(
              value: selectedWaterAmount,
              min: 100,
              max: 2000,
              divisions: 38,
              label: '${selectedWaterAmount.toInt()} ml',
              onChanged: (value) => setState(() => selectedWaterAmount = value),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final totalAfterAdd = current + selectedWaterAmount.toInt();
                if (totalAfterAdd > goal) {
                  final allowedToAdd = goal - current;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'You can only add up to $allowedToAdd ml to reach your goal.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  await waterProvider.addWaterIntake(
                    selectedWaterAmount.toInt(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added ${selectedWaterAmount.toInt()} ml of water!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Add Water'),
            ),
          ],
        ),
      ),
    );
  }
}
