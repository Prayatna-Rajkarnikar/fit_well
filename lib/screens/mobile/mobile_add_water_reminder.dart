import 'package:fit_well/providers/water_provider.dart';
import 'package:fit_well/screens/mobile/mobile_water_reminder_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddWaterReminder extends StatefulWidget {
  final String userId;
  const AddWaterReminder({Key? key, required this.userId}) : super(key: key);

  @override
  State<AddWaterReminder> createState() => _AddWaterReminderState();
}

class _AddWaterReminderState extends State<AddWaterReminder> {
  double waterAmount = 2000;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Set Water Goal')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text('Set your daily water goal', style: textTheme.headlineSmall),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    waterAmount.toInt().toString(),
                    style: textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'ml',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Slider(
              value: waterAmount,
              min: 100,
              max: 4000,
              divisions: 39,
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
              label: "${waterAmount.toInt()} ml",
              onChanged: (value) {
                setState(() {
                  waterAmount = value;
                });
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final waterProvider = Provider.of<WaterProvider>(
                  context,
                  listen: false,
                );

                try {
                  await waterProvider.setWaterGoal(waterAmount.toInt());

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Goal set for ${waterAmount.toInt()} ml of water!',
                      ),
                      backgroundColor: colorScheme.primary,
                    ),
                  );

                  // Navigate to WaterReminderScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ChangeNotifierProvider.value(
                            value: waterProvider,
                            child: const WaterReminderScreen(),
                          ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to set water goal: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Center(child: Text('Set Goal')),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
