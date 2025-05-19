import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_well/providers/water_provider.dart';
import 'package:fit_well/service/notification_service.dart';

class WaterReminderScreen extends StatefulWidget {
  const WaterReminderScreen({Key? key}) : super(key: key);

  @override
  _WaterReminderScreenState createState() => _WaterReminderScreenState();
}

class _WaterReminderScreenState extends State<WaterReminderScreen> {
  final NotificationService _notificationService = NotificationService();
  Timer? notificationTimer;

  double selectedWaterAmount = 500;

  @override
  void initState() {
    super.initState();

    _notificationService.init();

    Provider.of<WaterProvider>(
      context,
    ).loadIntake();

    notificationTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      final waterProvider = Provider.of<WaterProvider>(context, listen: false);
      final current = waterProvider.?.totalIntakeMl ?? 0;
      final goal = waterProvider.intakeData?.goalMl ?? 2500;

      _notificationService.showWaterGoalNotification(current, goal);
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
    final current = waterProvider.intakeData?.totalIntakeMl ?? 0;
    final goal = waterProvider.intakeData?.goalMl ?? 2500;

    return Scaffold(
      appBar: AppBar(title: const Text('Water Tracker')),
      body: waterProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
              style: Theme.of(context).textTheme.headline6,
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
                      content: Text('You can only add up to $allowedToAdd ml to reach your goal.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  await waterProvider.addWater(widget.userId, selectedWaterAmount.toInt());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${selectedWaterAmount.toInt()} ml of water!'),
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
