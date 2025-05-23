import 'package:fit_well/screens/wera%20os/wear_add_timer.dart';
import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class WearSetTimerScreen extends StatefulWidget {
  const WearSetTimerScreen({super.key});

  @override
  State<WearSetTimerScreen> createState() => _WearSetTimerScreenState();
}

class _WearSetTimerScreenState extends State<WearSetTimerScreen> {
  int selectedMinutes = 0;
  int selectedSeconds = 0;

  final List<int> minutes = List.generate(60, (index) => index);
  final List<int> seconds = List.generate(60, (index) => index);

  late FixedExtentScrollController _minutesController;
  late FixedExtentScrollController _secondsController;

  @override
  void initState() {
    super.initState();
    _minutesController = FixedExtentScrollController(initialItem: selectedMinutes);
    _secondsController = FixedExtentScrollController(initialItem: selectedSeconds);
  }

  @override
  void dispose() {
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _navigateToTimerScreen() {
    if (selectedMinutes > 0 || selectedSeconds > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WearAddTimerScreen(
            selectedDuration: Duration(minutes: selectedMinutes, seconds: selectedSeconds),
          ),
        ),
      );
    }
  }

  String _formatTime(int min, int sec) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(min)}:${twoDigits(sec)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
               Text(
                "Timer",
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              const SizedBox(height: 20),

              // Wheel Pickers
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildWheel(
                      controller: _minutesController,
                      valueList: minutes,
                      onChanged: (val) => setState(() => selectedMinutes = val),
                      selectedValue: selectedMinutes,
                    ),
                    const SizedBox(width: 10),
                    _buildWheel(
                      controller: _secondsController,
                      valueList: seconds,
                      onChanged: (val) => setState(() => selectedSeconds = val),
                      selectedValue: selectedSeconds,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Set Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: (selectedMinutes > 0 || selectedSeconds > 0)
                        ? _navigateToTimerScreen
                        : null,

                    child: const Text(
                      'Set',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required List<int> valueList,
    required ValueChanged<int> onChanged,
    required int selectedValue,
  }) {
    return SizedBox(
      width: 50,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 30,
        perspective: 0.005,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            bool isSelected = valueList[index] == selectedValue;
            return Center(
              child: Text(
                valueList[index].toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: isSelected ? 22 : 16,
                  color: isSelected ? AppColors.myGreen : AppColors.myGray,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
          childCount: valueList.length,
        ),
      ),
    );
  }
}