import 'package:fit_well/providers/theme_provider.dart';
import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 24, color: themeProvider.isDarkMode ? AppColors.myWhite : AppColors.myBlack,),
              const SizedBox(height: 8),
              Text(
                'You are not authenticated',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _authorize,

                child: const Text(
                  "Authorize from Mobile",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
