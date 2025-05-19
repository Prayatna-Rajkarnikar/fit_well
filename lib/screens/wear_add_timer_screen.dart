import 'package:flutter/material.dart';
import 'dart:async';

class WearAddTimerScreen extends StatefulWidget {
  final Duration selectedDuration;

  // Constructor that accepts the selected duration from previous screen
  const WearAddTimerScreen({super.key, required this.selectedDuration});

  @override
  State<WearAddTimerScreen> createState() => _WearAddTimerScreenState();
}

class _WearAddTimerScreenState extends State<WearAddTimerScreen> {
  late Duration initialDuration;
  late Duration remaining;
  Timer? timer;
  bool isRunning = true;
  double progress = 1.0; // For progress indicator

  @override
  void initState() {
    super.initState();
    // Initialize with the duration passed from the previous screen
    initialDuration = widget.selectedDuration;
    remaining = widget.selectedDuration;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining.inSeconds > 0) {
        setState(() {
          remaining = remaining - const Duration(seconds: 1);
          // Calculate progress percentage
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
    setState(() {
      isRunning = false;
    });
  }

  void resumeTimer() {
    startTimer();
    setState(() {
      isRunning = true;
    });
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
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular progress indicator
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[800],
                  color: _getProgressColor(),
                ),
              ),

              // Timer content in the center
              ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 20,
                ),
                children: [
                  Center(
                    child: Text(
                      formatDuration(remaining),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      initialDuration.inMinutes > 0 ? 'min' : 'sec',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Reset button
                      IconButton(
                        iconSize: 32,
                        icon: const Icon(Icons.refresh, color: Colors.red),
                        onPressed: resetTimer,
                      ),
                      const SizedBox(width: 30),
                      // Play/Pause button
                      ElevatedButton(
                        onPressed: isRunning ? pauseTimer : resumeTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isRunning ? Colors.orange : Colors.green,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: Icon(
                          isRunning ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 30),
                      // Back button to return to timer selection
                      IconButton(
                        iconSize: 32,
                        icon: const Icon(Icons.timer, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dynamic color based on remaining time
  Color _getProgressColor() {
    if (progress > 0.6) return Colors.green;
    if (progress > 0.3) return Colors.orange;
    return Colors.red;
  }
}
