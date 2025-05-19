import 'package:fit_well/screens/mobile/mobile_add_calories_screen.dart';
import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class CaloriesScreen extends StatelessWidget {
  final double calories;

  const CaloriesScreen({Key? key, required this.calories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.myGreen),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
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
                        text: calories.toStringAsFixed(0),
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
