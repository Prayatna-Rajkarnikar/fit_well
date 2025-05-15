import 'package:fit_well/screens/wera%20os/wear_add_calorie_screen.dart';
import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear_plus/wear_plus.dart';

import '../../providers/calorie_provider.dart';
import '../../providers/watch_provider.dart';

class WearCalorieScreen extends StatefulWidget {
  const WearCalorieScreen({super.key});

  @override
  State<WearCalorieScreen> createState() => _WearCalorieScreenState();
}

class _WearCalorieScreenState extends State<WearCalorieScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<WatchProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CalorieProvider>(
        context,
        listen: false,
      ).fetchCaloriesBurned();
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
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        calorieProvider.isLoading
                            ? Text(
                              '0.0',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            : Text(
                              totalCalories.toString(),
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        Text(
                          "kcal",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.myGreen),
                        ),
                      ],
                    ),

                    Text('Calories Burned'),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WearAddCalorieScreen(),
                          ),
                        );
                      },
                      child: Text("Add"),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
