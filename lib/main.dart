import 'package:fit_well/providers/calorie_provider.dart';
import 'package:fit_well/providers/watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:fit_well/screens/signin_screen.dart';
import 'package:fit_well/screens/wear_home_screen.dart';
import 'package:fit_well/providers/theme_provider.dart';
import 'package:fit_well/providers/auth_provider.dart';
import 'package:fit_well/utils/theme.dart';
import 'package:is_wear/is_wear.dart';
import 'package:provider/provider.dart';

late final bool isWear;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  isWear = (await IsWear().check()) ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WatchProvider()),
        ChangeNotifierProvider(create: (_) => CalorieProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fit Well",
      home: isWear ? const WearHomeScreen() : const SignInScreen(),
      themeMode: themeProvider.themeMode,
      theme: MyTheme.lightTheme(isWear: isWear),
      darkTheme: MyTheme.darkTheme(isWear: isWear),
    );
  }
}
