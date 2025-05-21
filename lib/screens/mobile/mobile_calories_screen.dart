import 'package:fit_well/screens/mobile/mobile_add_calories_screen.dart';
import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/calorie_provider.dart';
import '../../providers/theme_provider.dart';

class CaloriesScreen extends StatefulWidget {
  const CaloriesScreen({Key? key}) : super(key: key);

  @override
  State<CaloriesScreen> createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends State<CaloriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CalorieProvider>(context, listen: false).fetchCaloriesBurned();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final calorieProvider = Provider.of<CalorieProvider>(context);
    final isLoading = calorieProvider.isLoading;
    final totalCalories = calorieProvider.totalCalorieData?.totalCaloriesBurned ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Calorie',style: Theme.of(context).textTheme.headlineLarge,),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Column(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: isLoading
                            ? '0'
                            : totalCalories.toStringAsFixed(0),
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 65,
                        ),
                      ),
                      TextSpan(
                        text: ' kcal',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.myGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Calories Burned',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.myGray,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCalorieScreen(),
                      ),
                    );
                  },
                  child: Text('Add'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
