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

    final watchUser = Provider.of<WatchProvider>(context, listen: false).userData;
    if (watchUser['weightKg'] != null) {
      weight = watchUser['weightKg'].toInt();
    }
  }

  void _showUpdateWeightDialog(BuildContext context) {
    final TextEditingController _weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                    final newWeight = double.tryParse(_weightController.text);
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
    final calorieProvider = Provider.of<CalorieProvider>(context, listen: false);

    if (selectedActivity == null) {
      _showDialog("Error", "Please select an activity.");
      return;
    }

    try {
      await calorieProvider.addCalories(selectedActivity!, selectedHour);
      await calorieProvider.fetchCaloriesBurned(); // Ensure updated data

      Navigator.of(context).pop(); // Navigate to Calories screen
    } catch (e) {
      _showDialog("Failed", "Failed to add calories: $e");
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
      body: activities == null
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),

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
                    icon: Icon(Icons.edit, size: 18),
                    onPressed: () => _showUpdateWeightDialog(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Activity label
            Center(
              child: Text('Activity', style: textTheme.headlineLarge),
            ),
            SizedBox(height: 10),

            // Activity dropdown
            Center(
              child: DropdownButton<String>(
                value: selectedActivity,
                hint: Text("Choose activity"),
                items: activities
                    .map<DropdownMenuItem<String>>((activity) {
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

            SizedBox(height: 20),

            // Duration input (Hours only)
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

            Spacer(),

            // Submit button
            Center(
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: Text("Submit"),
              ),
            ),

            Spacer(),
          ],
        ),
      ),
    );
  }
}
