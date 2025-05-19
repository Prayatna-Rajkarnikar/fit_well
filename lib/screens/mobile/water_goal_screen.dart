import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/water_provider.dart';

class WaterGoalScreen extends StatefulWidget {
  const WaterGoalScreen({Key? key}) : super(key: key);

  @override
  _WaterGoalScreenState createState() => _WaterGoalScreenState();
}

class _WaterGoalScreenState extends State<WaterGoalScreen> {
  final TextEditingController _goalController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentGoal();
  }

  void _loadCurrentGoal() {
    final currentGoal = Provider.of<WaterProvider>(context, listen: false).waterGoal;
    _goalController.text = currentGoal.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Water Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Daily Water Goal (ml)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isSaving
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                final goal = int.tryParse(_goalController.text) ?? 0;
                if (goal > 0) {
                  setState(() => _isSaving = true);
                  try {
                    await Provider.of<WaterProvider>(context, listen: false)
                        .setWaterGoal(goal);
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  } finally {
                    setState(() => _isSaving = false);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid amount')),
                  );
                }
              },
              child: const Text('Save Goal'),
            ),
          ],
        ),
      ),
    );
  }
}