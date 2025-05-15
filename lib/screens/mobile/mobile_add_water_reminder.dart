import 'package:fit_well/providers/water_provider.dart';
import 'package:fit_well/screens/mobile/mobile_water_reminder_screen.dart';
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Water Reminder',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              'Set Water Goal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    waterAmount.toInt().toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'ml',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
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
              activeColor: Colors.green,
              inactiveColor: Colors.white24,
              label: "${waterAmount.toInt()} ml",
              onChanged: (value) {
                setState(() {
                  waterAmount = value;
                });
              },
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                final waterProvider = Provider.of<WaterProvider>(
                  context,
                  listen: false,
                );
                waterProvider.setGoal(waterAmount.toInt());

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Goal set for ${waterAmount.toInt()} ml of water!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => WaterReminderScreen(
                          userId: 'user_123',
                        ), // Replace with your actual userId
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Center(
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
