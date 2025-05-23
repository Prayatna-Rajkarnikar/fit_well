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
    final currentGoal =
        Provider.of<WaterProvider>(context, listen: false).waterGoal;
    _goalController.text = currentGoal.toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set Water Goal',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
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
              ),
            ),
            const SizedBox(height: 20),
            _isSaving
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () async {
                    final goal = int.tryParse(_goalController.text) ?? -1;
                    if (goal > 0) {
                      setState(() => _isSaving = true);
                      try {
                        await Provider.of<WaterProvider>(
                          context,
                          listen: false,
                        ).setWaterGoal(goal);
                        _showSnackBar(
                          success: true,
                          message: "Water goal saved successfully!",
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        _showSnackBar(success: false, message: "Error: $e");
                      } finally {
                        setState(() => _isSaving = false);
                      }
                    } else {
                      _showSnackBar(
                        success: false,
                        message: 'Please enter a valid positive amount',
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
