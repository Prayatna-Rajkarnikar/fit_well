import 'dart:async';
import 'package:fit_well/screens/mobile/mobile_timer_screen.dart';
import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class SetTimerScreen extends StatefulWidget {
  const SetTimerScreen({super.key});

  @override
  State<SetTimerScreen> createState() => _SetTimerScreenState();
}

class _SetTimerScreenState extends State<SetTimerScreen> {
  int selectedMinutes = 0;
  int selectedSeconds = 0;
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
            title: Text(
              'Time’s up!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            content: Text(
              'The timer has finished.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  resetTimer();
                },
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
    );
  }

  void _showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: AppColors.myWhite, fontSize: 16),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.timer,
              color:
                  themeProvider.isDarkMode
                      ? AppColors.myWhite
                      : AppColors.myBlack,
            ),
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
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontSize: 65),
            ),
            Text(
              'min : sec',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.myGray),
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
                      backgroundColor: AppColors.myGreen,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 36,
                      color: AppColors.myBlack,
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
                      color: AppColors.myBlack,
                    ),
                  ),
                if (isPaused)
                  ElevatedButton(
                    onPressed: resumeTimer,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: AppColors.myGreen,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 36,
                      color: AppColors.myWhite,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _showTimePickerDialog,

              child: const Text('Set Time'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _showTimePickerDialog() {
    int tempMinutes = selectedMinutes;
    int tempSeconds = selectedSeconds;

    showDialog(
      context: context,
      builder: (context) {
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
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (tempMinutes < 0 || tempSeconds < 0) {
                  Navigator.pop(context);
                  _showCustomSnackBar('Time cannot be negative!');
                  return;
                }

                if (tempMinutes == 0 && tempSeconds == 0) {
                  Navigator.pop(context);
                  _showCustomSnackBar('Timer duration must be greater than 0');
                  return;
                }

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
