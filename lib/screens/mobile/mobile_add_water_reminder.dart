import 'package:fit_well/providers/water_provider.dart';
import 'package:fit_well/screens/mobile/mobile_water_reminder_screen.dart';
import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddWaterReminder extends StatefulWidget {
  const AddWaterReminder({Key? key}) : super(key: key);

  @override
  State<AddWaterReminder> createState() => _AddWaterReminderState();
}

class _AddWaterReminderState extends State<AddWaterReminder> {
  double waterAmount = 500;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text('Set Water Goal', style: textTheme.labelLarge),
            const SizedBox(height: 20),
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
              max: 2000,
              divisions: 38,
              activeColor: AppColors.myGreen,
              inactiveColor: AppColors.myBlack,
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

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WaterReminderScreen(),
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
              child: Center(child: Text('Add')),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
