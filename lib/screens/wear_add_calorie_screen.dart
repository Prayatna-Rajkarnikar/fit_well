import 'package:fit_well/providers/calorie_provider.dart';
import 'package:fit_well/screens/wear_calorie_screen.dart';
import 'package:fit_well/utils/custom_themes/colors.dart';
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Text(
                          "Weight",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 4,
                          children: [
                            Text(
                              "65",
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            Text(
                              "kg",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.myGreen),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit,size: 12,),
                          onPressed: () {
                          },
                        ),
                      ],
                    ),

                    Text(
                      "Activity",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(
                      height: 24,
                      width: MediaQuery.of(context).size.width*0.7,
                      child: DropdownButtonFormField<String>(
                        value: selectedActivity,
                        items: activities.map<DropdownMenuItem<String>>((activity) {
                          return DropdownMenuItem<String>(
                            value: activity.activity,
                            child: Text(activity.activity, style: Theme.of(context).textTheme.headlineLarge,),
                          );
                        }).toList(),

                        onChanged: (String? newValue) {
                          setState(() {
                            selectedActivity = newValue;
                          });
                        },
                        hint: Text("Choose activity"),
                        style: Theme.of(context).textTheme.bodyMedium
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        SizedBox(
                          height: 24,
                          width: MediaQuery.of(context).size.width*0.2,
                          child: TextFormField(
                            style: Theme.of(context).textTheme.headlineLarge,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Num',
                            ),
                            onChanged: (value) {
                              setState(() {
                                durationHours = int.tryParse(value);
                              });
                            },
                          ),
                        ),
                        Text("h", style:  Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.myGreen),)
                      ],
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedActivity != null && durationHours != null) {
                            try {
                              await calorieProvider.addCalories(selectedActivity!, durationHours!);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WearCalorieScreen(),));
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: const Text('Success'),
                                  content: const Text('Action was successful.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              });
                            } catch (e) {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: const Text('Failed'),
                                  content: Text("Failed to add calories: $e"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              });
                            }
                          } else {
                           showDialog(context: context, builder: (context) {
                             return AlertDialog(title: Text("Error"),
                             content: Text("Please fill all the fields"),
                               actions: [
                                 TextButton(
                                   onPressed: () => Navigator.of(context).pop(),
                                   child: const Text('OK'),
                                 ),
                               ],
                             );
                           },);
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
