import 'dart:async';

import 'package:flutter/material.dart';

class AddTimerScreen extends StatefulWidget {
  @override
  _AddTimerScreenState createState() => _AddTimerScreenState();
}

class _AddTimerScreenState extends State<AddTimerScreen> {
  Duration initialDuration = const Duration(minutes: 0, seconds: 0);
  Duration remaining = const Duration(minutes: 0, seconds: 0);
  Timer? timer;
  bool isRunning = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Timer starts only after user hits start button now
  }

  void startTimer() {
    if (remaining.inSeconds == 0) return;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining.inSeconds > 0) {
        setState(() {
          remaining = remaining - const Duration(seconds: 1);
        });
      } else {
        timer?.cancel();
        setState(() {
          isRunning = false;
        });
        _showNotification();
      }
    });
    setState(() {
      isRunning = true;
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resumeTimer() {
    if (remaining.inSeconds == 0) return;
    startTimer();
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      initialDuration = Duration.zero; // reset initialDuration to 00:00
      remaining = Duration.zero; // reset remaining to 00:00
      isRunning = false;
    });
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Future<void> _showSetTimeDialog() async {
    _minutesController.text = remaining.inMinutes.toString();
    _secondsController.text = (remaining.inSeconds % 60).toString();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Timer'),
          content: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _minutesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Minutes'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter minutes';
                      }
                      final n = int.tryParse(value);
                      if (n == null || n < 0) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _secondsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Seconds'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter seconds';
                      }
                      final n = int.tryParse(value);
                      if (n == null || n < 0 || n > 59) {
                        return '0-59 only';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final minutes = int.parse(_minutesController.text);
                  final seconds = int.parse(_secondsController.text);
                  setState(() {
                    initialDuration = Duration(
                      minutes: minutes,
                      seconds: seconds,
                    );
                    remaining = initialDuration;
                    isRunning = false;
                    timer?.cancel();
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }

  void _showNotification() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Timer Finished'),
            content: const Text('Your timer has ended!'),
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
  void dispose() {
    timer?.cancel();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formatDuration(remaining),
                style: textTheme.headlineLarge?.copyWith(
                  color: colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'min : sec',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 50,
                    icon: Icon(Icons.refresh, color: Colors.red),
                    onPressed: resetTimer,
                    tooltip: 'Reset',
                  ),
                  const SizedBox(width: 30),
                  if (!isRunning)
                    ElevatedButton(
                      onPressed: startTimer,
                      child: const Text('Start'),
                    )
                  else
                    ElevatedButton(
                      onPressed: pauseTimer,
                      child: const Text('Pause'),
                    ),
                  const SizedBox(width: 10),
                  if (!isRunning && remaining.inSeconds > 0)
                    ElevatedButton(
                      onPressed: resumeTimer,
                      child: const Text('Resume'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
