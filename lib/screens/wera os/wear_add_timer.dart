import 'package:flutter/material.dart';
import 'dart:async';

class WearAddTimerScreen extends StatefulWidget {
  final Duration selectedDuration;

  const WearAddTimerScreen({super.key, required this.selectedDuration});

  @override
  State<WearAddTimerScreen> createState() => _WearAddTimerScreenState();
}

class _WearAddTimerScreenState extends State<WearAddTimerScreen> {
  late Duration initialDuration;
  late Duration remaining;
  Timer? timer;
  bool isRunning = true;
  double progress = 1.0;

  @override
  void initState() {
    super.initState();
    initialDuration = widget.selectedDuration;
    remaining = initialDuration;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining.inSeconds > 0) {
        setState(() {
          remaining -= const Duration(seconds: 1);
          progress = remaining.inSeconds / initialDuration.inSeconds;
        });
      } else {
        timer?.cancel();
        setState(() {
          isRunning = false;
          progress = 0;
        });
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void resumeTimer() {
    startTimer();
    setState(() => isRunning = true);
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      remaining = initialDuration;
      isRunning = true;
      progress = 1.0;
    });
    startTimer();
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Color _getProgressColor() {
    if (progress > 0.6) return Colors.green;
    if (progress > 0.3) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular Progress
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: Colors.grey[800],
                      color: _getProgressColor(),
                    ),
                  ),
                  Text(
                    formatDuration(remaining),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 28,
                    icon: const Icon(Icons.refresh, color: Colors.red),
                    onPressed: resetTimer,
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: isRunning ? pauseTimer : resumeTimer,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      backgroundColor:
                      isRunning ? Colors.orange : Colors.green,
                    ),
                    child: Icon(
                      isRunning ? Icons.pause : Icons.play_arrow,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    iconSize: 14,
                    icon: const Icon(Icons.timer, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
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