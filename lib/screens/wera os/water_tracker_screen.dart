// import 'package:fit_well/providers/water_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class WaterTrackerWearScreen extends StatefulWidget {
//   final String userId;
//   const WaterTrackerWearScreen({super.key, required this.userId});
//
//   @override
//   State<WaterTrackerWearScreen> createState() => _WaterTrackerWearScreenState();
// }
//
// class _WaterTrackerWearScreenState extends State<WaterTrackerWearScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<WaterProvider>(
//       context,
//       listen: false,
//     ).loadIntake(widget.userId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<WaterProvider>(context);
//     final data = provider.intakeData;
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body:
//           provider.loading
//               ? const Center(child: CircularProgressIndicator())
//               : data == null
//               ? const Center(
//                 child: Text(
//                   'No Data',
//                   style: TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//               )
//               : Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 20,
//                   horizontal: 10,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '${(data.totalIntakeMl / 1000).toStringAsFixed(1)} / ${(data.goalMl / 1000).toStringAsFixed(1)} L',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         shape: const CircleBorder(),
//                         padding: const EdgeInsets.all(20),
//                       ),
//                       onPressed: () {
//                         provider.addWater(widget.userId, 250); // 250 ml
//                       },
//                       child: const Icon(
//                         Icons.local_drink,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       'Tap to add 250ml',
//                       style: TextStyle(color: Colors.white, fontSize: 12),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }
// }
