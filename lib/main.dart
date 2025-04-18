import 'package:fit_well/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_well/screens/wear_home_screen.dart';
import 'package:fit_well/utils/theme.dart';
import 'package:is_wear/is_wear.dart';
import 'package:fit_well/providers/theme_provider.dart';

late final bool isWear;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  isWear = (await IsWear().check()) ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
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
      home: isWear ? const WearHomeScreen() : SignInScreen(),
      themeMode: themeProvider.themeMode,
      theme: MyTheme.lightTheme(isWear: isWear),
      darkTheme: MyTheme.darkTheme(isWear: isWear),
    );
  }
}
