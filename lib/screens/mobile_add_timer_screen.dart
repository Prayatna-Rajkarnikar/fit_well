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
  bool isRunning = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Timer',
          style: TextStyle(color: Colors.white),
        ),
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
          const Text(
            'min',
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
                onPressed: isRunning ? pauseTimer : resumeTimer,
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
          )
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
