// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:watch_connectivity/watch_connectivity.dart';
//
// class WatchProvider with ChangeNotifier {
//   final WatchConnectivity _watch = WatchConnectivity();
//   final Map<String, dynamic> _userData = {};
//
//   Map<String, dynamic> get userData => _userData;
//
//   WatchProvider() {
//     _watch.messageStream.listen((message) async {
//       if (message.containsKey('token')) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', message['token']);
//         debugPrint('✅ Token saved on watch: ${message['token']}');
//       } else {
//         debugPrint('⚠️ No token found in message.');
//       }
//     });
//   }
// }
