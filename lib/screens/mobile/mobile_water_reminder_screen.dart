import 'dart:async';

import 'package:fit_well/providers/water_provider.dart';
import 'package:fit_well/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaterReminderScreen extends StatefulWidget {
  final String userId;
  const WaterReminderScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<WaterReminderScreen> createState() => _WaterReminderScreenState();
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
      listen: false,
    ).loadIntake(widget.userId);

    notificationTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      final waterProvider = Provider.of<WaterProvider>(context, listen: false);
      final current = waterProvider.intakeData?.totalIntakeMl ?? 0;
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Water Tracker',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          waterProvider.loading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
              : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$current',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const TextSpan(
                            text: ' / ',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white70,
                            ),
                          ),
                          TextSpan(
                            text: '$goal',
                            style: const TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                            ),
                          ),
                          const TextSpan(
                            text: ' ml',
                            style: TextStyle(fontSize: 20, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${selectedWaterAmount.toInt()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'ml',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Slider(
                      value: selectedWaterAmount,
                      min: 100,
                      max: 2000,
                      divisions: 38,
                      activeColor: Colors.green,
                      inactiveColor: Colors.white24,
                      label: '${selectedWaterAmount.toInt()} ml',
                      onChanged:
                          (value) =>
                              setState(() => selectedWaterAmount = value),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        final totalAfterAdd =
                            current + selectedWaterAmount.toInt();

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
                          await waterProvider.addWater(
                            widget.userId,
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 50,
                        ),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }
}
