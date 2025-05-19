import 'package:flutter/material.dart';
import 'dart:async';
import 'wear_add_timer_screen.dart';

class WearTimerScreen extends StatefulWidget {
  const WearTimerScreen({super.key});

  @override
  State<WearTimerScreen> createState() => _WearTimerScreenState();
}

class _WearTimerScreenState extends State<WearTimerScreen> {
  Duration duration = const Duration();
  Timer? timer;
  bool isRunning = false;

  // Controllers for the ListWheelScrollViews
  late FixedExtentScrollController _minutesController;
  late FixedExtentScrollController _secondsController;

  // Lists of minutes and seconds
  final List<int> minutes = List.generate(60, (index) => index);
  final List<int> seconds = List.generate(60, (index) => index);

  // Selected values
  int selectedMinutes = 0;
  int selectedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _minutesController = FixedExtentScrollController(
      initialItem: selectedMinutes,
    );
    _secondsController = FixedExtentScrollController(
      initialItem: selectedSeconds,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void startTimer() {
    // Set the duration based on selected values if timer is not already running
    if (!isRunning) {
      duration = Duration(minutes: selectedMinutes, seconds: selectedSeconds);
    }

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (duration.inSeconds > 0) {
          duration = duration - const Duration(seconds: 1);
        } else {
          timer?.cancel();
          isRunning = false;
        }
      });
    });
  }

  void toggleTimer() {
    if (isRunning) {
      timer?.cancel();
    } else {
      startTimer();
    }
    setState(() {
      isRunning = !isRunning;
    });
  }

  void setTimer() {
    // Navigate to WearAddTimerScreen with selected duration
    if (selectedMinutes > 0 || selectedSeconds > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => WearAddTimerScreen(
                selectedDuration: Duration(
                  minutes: selectedMinutes,
                  seconds: selectedSeconds,
                ),
              ),
        ),
      );
    }
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      duration = Duration(minutes: selectedMinutes, seconds: selectedSeconds);
      isRunning = false;
    });
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Widget _buildTimeWheel() {
    if (isRunning) {
      return Center(
        child: Text(
          formatDuration(duration),
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Minutes wheel
        SizedBox(
          width: 70,
          height: 150,
          child: ListWheelScrollView.useDelegate(
            controller: _minutesController,
            itemExtent: 50,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              setState(() {
                selectedMinutes = minutes[index];
                duration = Duration(
                  minutes: selectedMinutes,
                  seconds: selectedSeconds,
                );
              });
            },
            perspective: 0.005,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                bool isSelected =
                    minutes[index] == selectedMinutes && !isRunning;
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey[800] : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      minutes[index].toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: isSelected ? 28 : 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.green : Colors.white,
                      ),
                    ),
                  ),
                );
              },
              childCount: minutes.length,
            ),
          ),
        ),

        // Colon separator
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: const Text(
            ":",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        // Seconds wheel
        SizedBox(
          width: 70,
          height: 150,
          child: ListWheelScrollView.useDelegate(
            controller: _secondsController,
            itemExtent: 50,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              setState(() {
                selectedSeconds = seconds[index];
                duration = Duration(
                  minutes: selectedMinutes,
                  seconds: selectedSeconds,
                );
              });
            },
            perspective: 0.005,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                bool isSelected =
                    seconds[index] == selectedSeconds && !isRunning;
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey[800] : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      seconds[index].toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: isSelected ? 28 : 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.green : Colors.white,
                      ),
                    ),
                  ),
                );
              },
              childCount: seconds.length,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                "Set Timer",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // Time selection wheels
              _buildTimeWheel(),

              const Spacer(),

              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Reset button (only shown when timer is running or paused with time elapsed)
                  if (isRunning ||
                      duration.inSeconds <
                          (selectedMinutes * 60 + selectedSeconds))
                    ElevatedButton(
                      onPressed: resetTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Icon(
                        Icons.refresh,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),

                  const SizedBox(width: 20),

                  // Set button (to confirm selection and navigate to WearAddTimerScreen)
                  ElevatedButton(
                    onPressed:
                        (selectedMinutes > 0 || selectedSeconds > 0)
                            ? setTimer
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      disabledBackgroundColor: Colors.grey[800],
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
