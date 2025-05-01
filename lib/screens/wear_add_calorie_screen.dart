import 'package:fit_well/providers/calorie_provider.dart';
import 'package:fit_well/screens/wear_calorie_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear_plus/wear_plus.dart';

class WearAddCalorieScreen extends StatefulWidget {
  const WearAddCalorieScreen({super.key});

  @override
  State<WearAddCalorieScreen> createState() => _WearAddCalorieScreenState();
}

class _WearAddCalorieScreenState extends State<WearAddCalorieScreen> {
  String? selectedActivity;
  int? durationHours;

  @override
  void initState() {
    super.initState();
    Provider.of<CalorieProvider>(context, listen: false).getAllActivities();
  }

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      builder: (context, mode, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Consumer<CalorieProvider>(
              builder: (context, calorieProvider, child) {
                final activities = calorieProvider.activity;

                if (activities == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  spacing: 10.0,
                  children: [
                    Text(
                      "Activity",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedActivity,
                      items: activities.map<DropdownMenuItem<String>>((activity) {
                        return DropdownMenuItem<String>(
                          value: activity.activity,
                          child: Text(activity.activity),
                        );
                      }).toList(),

                      onChanged: (String? newValue) {
                        setState(() {
                          selectedActivity = newValue;
                        });
                      },
                      hint: const Text("Choose activity"),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Duration in hours',
                      ),
                      onChanged: (value) {
                        setState(() {
                          durationHours = int.tryParse(value);
                        });
                      },
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedActivity != null && durationHours != null) {
                            try {
                              await calorieProvider.addCalories(selectedActivity!, durationHours!);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WearCalorieScreen(),));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Calories added successfully!")),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Failed: $e")),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please select an activity and enter duration.")),
                            );
                          }
                        },
                        child: const Text("Submit"),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
