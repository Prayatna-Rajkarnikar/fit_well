import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'wear_home_screen.dart';

class WearSignInScreen extends StatefulWidget {
  const WearSignInScreen({super.key});

  @override
  State<WearSignInScreen> createState() => _WearSignInScreenState();
}

class _WearSignInScreenState extends State<WearSignInScreen> {
  final WatchConnectivity _watch = WatchConnectivity();
  String? _mobileToken;

  @override
  void initState() {
    super.initState();

    _watch.messageStream.listen((message) async {
      if (message.containsKey('token')) {
        _mobileToken = message['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _mobileToken!);

        if (await _isTokenValid()) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WearHomeScreen()),
          );
        }
      }
    });
  }

  Future<bool> _isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final localToken = prefs.getString('token');

    return localToken != null && localToken == _mobileToken;
  }

  Future<void> _authorize() async {
    try {
      await _watch.sendMessage({'request': 'auth_token'});
    } catch (e) {
      debugPrint("Failed to request token: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _authorize,
          child: const Text("Authorize from Mobile"),
        ),
      ),
    );
  }
}
