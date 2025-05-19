import 'package:fit_well/providers/theme_provider.dart';
import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:fit_well/screens/mobile/mobile_calories_screen.dart';
import 'package:provider/provider.dart';

class AddCalorieScreen extends StatefulWidget {
  @override
  _AddCalorieScreenState createState() => _AddCalorieScreenState();
}

class _AddCalorieScreenState extends State<AddCalorieScreen> {
  String selectedActivity = 'Running';
  int selectedHour = 1;
  int selectedMinute = 10;
  int weight = 70;

  double? caloriesBurned;

  double calculateCalories(
    String activity,
    int weightKg,
    int hours,
    int minutes,
  ) {
    final Map<String, double> metValues = {
      'Running': 9.8,
      'Walking': 3.5,
      'Cycling': 7.5,
    };

    double met = metValues[activity] ?? 1.0;
    double durationInHours = hours + (minutes / 60.0);

    return met * weightKg * durationInHours;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Calorie",
          style: textTheme.headlineLarge
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),

            // Weight
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Weight ',
                  style: textTheme.headlineLarge,
                  children: [
                    TextSpan(
                      text: '$weight',
                      style: textTheme.headlineLarge
                    ),
                    TextSpan(
                      text: ' kg',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.myGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Activity label
            Center(
              child: Text(
                'Activity',
                style: textTheme.headlineLarge
              ),
            ),
            SizedBox(height: 10),

            // Activity dropdown
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  // example surface variant color for dropdown bg
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<String>(
                  dropdownColor: themeProvider.isDarkMode ? AppColors.myGray : AppColors.myLightGray,
                  // dropdown bg color
                  value: selectedActivity,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: themeProvider.isDarkMode ? AppColors.myLightGray : AppColors.myGray,
                  ),
                  underline: SizedBox(),
                  style: textTheme.bodyMedium?.copyWith(
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedActivity = newValue!;
                    });
                  },
                  items:
                      [
                        'Running',
                        'Walking',
                        'Cycling',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Duration controls
            Center(
              child: Column(
                children: [
                  Text(
                    'Duration',
                    style: textTheme.bodyMedium
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Hour controls
                      Column(
                        children: [
                          Text(
                            'Hours',
                            style: textTheme.bodyMedium
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (selectedHour > 0) selectedHour--;
                                  });
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: themeProvider.isDarkMode ? AppColors.myWhite : AppColors.myBlack,
                                ),
                              ),
                              Text(
                                '$selectedHour',
                                style: textTheme.bodyMedium
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectedHour++;
                                  });
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: themeProvider.isDarkMode ? AppColors.myWhite : AppColors.myBlack,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 30),
                      // Minute controls
                      Column(
                        children: [
                          Text(
                            'Minutes',
                            style: textTheme.bodyMedium
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (selectedMinute > 0) selectedMinute -= 5;
                                  });
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: themeProvider.isDarkMode ? AppColors.myWhite : AppColors.myBlack,
                                ),
                              ),
                              Text(
                                '$selectedMinute',
                                style: textTheme.bodyMedium
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectedMinute += 5;
                                    if (selectedMinute >= 60) {
                                      selectedMinute = 0;
                                      selectedHour++;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: themeProvider.isDarkMode ? AppColors.myWhite : AppColors.myBlack,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Calories burned result
            if (caloriesBurned != null)
              Center(
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${caloriesBurned!.toStringAsFixed(0)}',
                            style: textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' kcal',
                            style: textTheme.headlineLarge?.copyWith(
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Calories Burned',
                      style: textTheme.bodyMedium?.copyWith(
                      ),
                    ),
                  ],
                ),
              ),

            Spacer(),

            // Calculate button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      caloriesBurned = calculateCalories(
                        selectedActivity,
                        weight,
                        selectedHour,
                        selectedMinute,
                      );
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                CaloriesScreen(calories: caloriesBurned!),
                      ),
                    );
                  },
                  child: Text('Calculate'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
