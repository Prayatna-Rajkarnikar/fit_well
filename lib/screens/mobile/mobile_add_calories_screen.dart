import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:fit_well/screens/mobile/mobile_calories_screen.dart';

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
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back arrow and title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: colorScheme.onBackground),
                  SizedBox(width: 10),
                  Text(
                    "Add Calorie",
                    style: textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Weight
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Weight ',
                  style: textTheme.headlineLarge?.copyWith(
                    color: colorScheme.onBackground,
                  ),
                  children: [
                    TextSpan(
                      text: '$weight',
                      style: textTheme.headlineLarge?.copyWith(
                        color: colorScheme.onBackground,
                      ),
                    ),
                    TextSpan(
                      text: ' kg',
                      style: textTheme.headlineLarge?.copyWith(
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
                style: textTheme.headlineLarge?.copyWith(
                  color: colorScheme.onBackground,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Activity dropdown
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color:
                      colorScheme
                          .surfaceVariant, // example surface variant color for dropdown bg
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<String>(
                  dropdownColor: colorScheme.surface, // dropdown bg color
                  value: selectedActivity,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: colorScheme.onSurface,
                  ),
                  underline: SizedBox(),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
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
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onBackground,
                    ),
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
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onBackground.withOpacity(0.7),
                            ),
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
                                  color: colorScheme.onBackground,
                                ),
                              ),
                              Text(
                                '$selectedHour',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onBackground,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectedHour++;
                                  });
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: colorScheme.onBackground,
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
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onBackground.withOpacity(0.7),
                            ),
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
                                  color: colorScheme.onBackground,
                                ),
                              ),
                              Text(
                                '$selectedMinute',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onBackground,
                                ),
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
                                  color: colorScheme.onBackground,
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
                              color: colorScheme.onBackground,
                            ),
                          ),
                          TextSpan(
                            text: ' kcal',
                            style: textTheme.headlineLarge?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Calories Burned',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.7),
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
