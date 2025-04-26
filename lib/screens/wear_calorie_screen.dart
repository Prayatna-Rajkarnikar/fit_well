import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear_plus/wear_plus.dart';

import '../providers/calorie_provider.dart';

class WearCalorieScreen extends StatefulWidget {
  const WearCalorieScreen({super.key});

  @override
  State<WearCalorieScreen> createState() => _WearCalorieScreenState();
}

class _WearCalorieScreenState extends State<WearCalorieScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 3)); // wait a bit
      if (mounted) {
        Provider.of<CalorieProvider>(
          context,
          listen: false,
        ).fetchCaloriesBurned();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final calorieProvider = Provider.of<CalorieProvider>(context);
    final totalCalories =
        calorieProvider.totalCalorieData?.totalCaloriesBurned ?? 0.0;

    return AmbientMode(
      builder:
          (context, mode, child) => Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: const Text('Calories Burned'),
                        subtitle:
                            calorieProvider.isLoading
                                ? const Text('No calorie')
                                : Text(
                                  '${totalCalories.toStringAsFixed(2)} kcal',
                                ),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
