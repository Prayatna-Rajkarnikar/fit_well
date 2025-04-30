import 'package:fit_well/providers/calorie_provider.dart';
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

  @override
  void initState() {
    super.initState();
    Provider.of<CalorieProvider>(context, listen: false).getAllActivities();
  }

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      builder: (context, mode, child) => Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Consumer<CalorieProvider>(builder: (context, calorieProvider, child) {
              final activities = calorieProvider.activity;

              if (activities == null) {
                return const Center(child: CircularProgressIndicator());
              }
            return Column(
              children: [
                Text(
                  "Select Activity",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  hint: const Text("Choose activity"),
                ),
              ],
            );
            },)
          ),
        ),
      ),
    );
  }
}
