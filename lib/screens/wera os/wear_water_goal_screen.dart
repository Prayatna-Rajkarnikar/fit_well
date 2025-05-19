import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/water_provider.dart';

class WearWaterGoalScreen extends StatefulWidget {
  const WearWaterGoalScreen({Key? key}) : super(key: key);

  @override
  State<WearWaterGoalScreen> createState() => _WaterGoalScreenState();
}

class _WaterGoalScreenState extends State<WearWaterGoalScreen> {
  final TextEditingController _goalController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final currentGoal = Provider.of<WaterProvider>(context, listen: false).waterGoal;
    _goalController.text = currentGoal.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Set Goal (ml)', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            _isSaving
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                final goal = int.tryParse(_goalController.text);
                if (goal != null && goal > 0) {
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
                    const SnackBar(content: Text('Enter a valid amount')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
