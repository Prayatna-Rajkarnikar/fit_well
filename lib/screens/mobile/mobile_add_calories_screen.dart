import 'package:fit_well/providers/calorie_provider.dart';
import 'package:fit_well/providers/theme_provider.dart';
import 'package:fit_well/providers/watch_provider.dart';
import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCalorieScreen extends StatefulWidget {
  @override
  _AddCalorieScreenState createState() => _AddCalorieScreenState();
}

class _AddCalorieScreenState extends State<AddCalorieScreen> {
  String? selectedActivity;
  int selectedHour = 1;
  int weight = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<CalorieProvider>(context, listen: false).getAllActivities();

    final watchUser =
        Provider.of<WatchProvider>(context, listen: false).userData;
    if (watchUser['weightKg'] != null) {
      weight = watchUser['weightKg'].toInt();
    }
  }

  void _showSnackBar({required bool success, required String message}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(success ? Icons.check_circle : Icons.error, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      elevation: 6,
      action: SnackBarAction(
        label: 'DISMISS',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showUpdateWeightDialog(BuildContext context) {
    final TextEditingController _weightController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            contentPadding: const EdgeInsets.all(16),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Update Weight"),
                const SizedBox(height: 10),
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Enter new weight (kg)",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Icon(Icons.cancel, size: 20),
                    ),
                    TextButton(
                      onPressed: () async {
                        final newWeight = double.tryParse(
                          _weightController.text,
                        );
                        if (newWeight == null || newWeight <= 0) {
                          Navigator.pop(context);
                          _showSnackBar(
                            success: false,
                            message:
                                "Please enter a positive number for weight.",
                          );
                          return;
                        }
                        if (newWeight != null) {
                          await Provider.of<CalorieProvider>(
                            context,
                            listen: false,
                          ).updateWeight(newWeight);
                          Provider.of<WatchProvider>(
                            context,
                            listen: false,
                          ).updateWeight(newWeight);
                          setState(() {
                            weight = newWeight.toInt();
                          });
                          Navigator.pop(context);
                          _showSnackBar(
                            success: true,
                            message: "Weight updated successfully!",
                          );
                        }
                      },
                      child: Icon(Icons.done_rounded, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _handleSubmit() async {
    final calorieProvider = Provider.of<CalorieProvider>(
      context,
      listen: false,
    );

    if (selectedActivity == null) {
      _showSnackBar(success: false, message: "Please select an activity.");
      return;
    }

    try {
      await calorieProvider.addCalories(selectedActivity!, selectedHour);
      await calorieProvider.fetchCaloriesBurned();

      _showSnackBar(success: true, message: "Calories added successfully!");
      Navigator.of(context).pop();
    } catch (e) {
      _showSnackBar(success: false, message: "Failed to add calories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final calorieProvider = Provider.of<CalorieProvider>(context);
    final activities = calorieProvider.activity;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Calorie", style: textTheme.headlineLarge),
      ),
      body:
          activities == null
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),

                    // Weight
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Weight ',
                              style: textTheme.headlineLarge,
                              children: [
                                TextSpan(
                                  text: '$weight',
                                  style: textTheme.headlineLarge,
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
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => _showUpdateWeightDialog(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Activity label
                    Center(
                      child: Text('Activity', style: textTheme.headlineLarge),
                    ),
                    const SizedBox(height: 10),

                    // Activity dropdown
                    Center(
                      child: DropdownButton<String>(
                        value: selectedActivity,
                        hint: const Text("Choose activity"),
                        items:
                            activities.map<DropdownMenuItem<String>>((
                              activity,
                            ) {
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
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: DropdownButton<int>(
                        value: selectedHour,
                        items: List.generate(10, (index) {
                          return DropdownMenuItem(
                            value: index,
                            child: Text('$index h'),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            selectedHour = value!;
                          });
                        },
                      ),
                    ),

                    const Spacer(),

                    // Submit button
                    Center(
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        child: const Text("Submit"),
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
    );
  }
}
