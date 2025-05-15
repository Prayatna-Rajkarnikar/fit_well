import 'package:fit_well/screens/mobile/mobile_calories_screen.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back arrow and title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Add Calorie",
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  children: [
                    TextSpan(
                      text: '$weight',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: ' kg',
                      style: TextStyle(color: Colors.green),
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
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            SizedBox(height: 10),

            // Activity dropdown
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey[900],
                  value: selectedActivity,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  underline: SizedBox(),
                  style: TextStyle(color: Colors.white, fontSize: 18),
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
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
                            style: TextStyle(color: Colors.white70),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (selectedHour > 0) selectedHour--;
                                  });
                                },
                                icon: Icon(Icons.remove, color: Colors.white),
                              ),
                              Text(
                                '$selectedHour',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectedHour++;
                                  });
                                },
                                icon: Icon(Icons.add, color: Colors.white),
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
                            style: TextStyle(color: Colors.white70),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (selectedMinute > 0) selectedMinute -= 5;
                                  });
                                },
                                icon: Icon(Icons.remove, color: Colors.white),
                              ),
                              Text(
                                '$selectedMinute',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
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
                                icon: Icon(Icons.add, color: Colors.white),
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
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: ' kcal',
                            style: TextStyle(fontSize: 24, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Calories Burned',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
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
                  child: Text(
                    'Calculate',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
