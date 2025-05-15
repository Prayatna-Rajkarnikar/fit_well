import 'package:flutter/material.dart';
import 'dart:async';

class AddTimerScreen extends StatefulWidget {
  const AddTimerScreen({Key? key}) : super(key: key);

  @override
  State<AddTimerScreen> createState() => _AddTimerScreenState();
}

class _AddTimerScreenState extends State<AddTimerScreen> {
  Duration initialDuration = const Duration(minutes: 3, seconds: 15);
  Duration remaining = const Duration(minutes: 3, seconds: 15);
  Timer? timer;
  bool isRunning = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // timer starts only after user hits start button now
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
    setState(() {
      isRunning = true;
    });
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
    // Simple alert dialog notification for demo
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

    // For real app use flutter_local_notifications package for system notifications
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Timer', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: _showSetTimeDialog,
            child: const Text(
              'Set Time',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatDuration(remaining),
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'min : sec',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                iconSize: 50,
                icon: const Icon(Icons.refresh, color: Colors.red),
                onPressed: resetTimer,
              ),
              ElevatedButton(
                onPressed: () {
                  if (isRunning) {
                    pauseTimer();
                  } else {
                    if (remaining.inSeconds == 0) {
                      setState(() {
                        remaining = initialDuration;
                      });
                    }
                    startTimer();
                    setState(() {
                      isRunning = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: Icon(
                  isRunning ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        currentIndex: 0,
        onTap: (index) {
          // Navigation logic here
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
