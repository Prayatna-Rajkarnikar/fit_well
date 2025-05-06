import 'package:fit_well/providers/water_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaterTrackerScreen extends StatefulWidget {
  final String userId;
  const WaterTrackerScreen({super.key, required this.userId});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<WaterProvider>(
      context,
      listen: false,
    ).loadIntake(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WaterProvider>(context);
    final data = provider.intakeData;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Water Tracker')),
      body:
          provider.loading
              ? const Center(child: CircularProgressIndicator())
              : data == null
              ? const Center(child: Text('No data found'))
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Today\'s Intake: ${data.totalIntakeLiters} L / ${data.goalLiters} L',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        provider.addWater(widget.userId, 0.25); // adds 250 ml
                      },
                      child: const Text('Add 250ml'),
                    ),
                  ],
                ),
              ),
    );
  }
}
