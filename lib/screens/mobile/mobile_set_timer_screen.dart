import 'dart:async';
import 'package:fit_well/screens/mobile/mobile_timer_screen.dart';
import 'package:flutter/material.dart';
// <-- Replace this with your actual import path

class SetTimerScreen extends StatefulWidget {
  const SetTimerScreen({super.key});

  @override
  State<SetTimerScreen> createState() => _SetTimerScreenState();
}

class _SetTimerScreenState extends State<SetTimerScreen> {
  int selectedMinutes = 3;
  int selectedSeconds = 15;
  late Duration remaining;
  Timer? timer;
  bool isRunning = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    remaining = Duration(minutes: selectedMinutes, seconds: selectedSeconds);
  }

  void startTimer() {
    if (remaining.inSeconds == 0) return;

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (remaining.inSeconds > 0) {
          remaining -= const Duration(seconds: 1);
        } else {
          t.cancel();
          isRunning = false;
          isPaused = false;
          _showFinishedDialog();
        }
      });
    });

    setState(() {
      isRunning = true;
      isPaused = false;
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() {
      isPaused = true;
      isRunning = false;
    });
  }

  void resumeTimer() {
    startTimer();
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      remaining = Duration(minutes: selectedMinutes, seconds: selectedSeconds);
      isRunning = false;
      isPaused = false;
    });
  }

  void _showFinishedDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
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

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TimerScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Text(
              formatDuration(remaining),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'min : sec',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.red, size: 40),
                  onPressed: resetTimer,
                ),
                const SizedBox(width: 40),
                if (!isRunning && !isPaused)
                  ElevatedButton(
                    onPressed: startTimer,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.orange,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                if (isRunning)
                  ElevatedButton(
                    onPressed: pauseTimer,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.yellow[700],
                    ),
                    child: const Icon(
                      Icons.pause,
                      size: 36,
                      color: Colors.black,
                    ),
                  ),
                if (isPaused)
                  ElevatedButton(
                    onPressed: resumeTimer,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.green,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                onPressed: () {
                  _showTimePickerDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size.fromHeight(60),
                ),
                child: const Text('Set', style: TextStyle(fontSize: 20)),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _showTimePickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        int tempMinutes = selectedMinutes;
        int tempSeconds = selectedSeconds;

        return AlertDialog(
          title: const Text('Set Timer'),
          content: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Minutes'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    tempMinutes = int.tryParse(value) ?? 0;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Seconds'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    int sec = int.tryParse(value) ?? 0;
                    tempSeconds = (sec > 59) ? 59 : sec;
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedMinutes = tempMinutes;
                  selectedSeconds = tempSeconds;
                  remaining = Duration(
                    minutes: selectedMinutes,
                    seconds: selectedSeconds,
                  );
                  isRunning = false;
                  isPaused = false;
                  timer?.cancel();
                });
                Navigator.pop(context);
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
