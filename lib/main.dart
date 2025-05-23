import 'package:firebase_core/firebase_core.dart';
import 'package:fit_well/providers/calorie_provider.dart';
import 'package:fit_well/providers/report_provider.dart';
import 'package:fit_well/providers/watch_provider.dart';
import 'package:fit_well/providers/water_provider.dart';
import 'package:fit_well/screens/mobile/mobile_add_calories_screen.dart';
import 'package:fit_well/screens/mobile/mobile_add_timer_screen.dart';
import 'package:fit_well/screens/mobile/mobile_calories_screen.dart';
import 'package:fit_well/screens/mobile/mobile_set_timer_screen.dart';
import 'package:fit_well/screens/mobile/mobile_timer_screen.dart';
import 'package:fit_well/screens/signin_screen.dart';
import 'package:fit_well/screens/wera%20os/wear_home_screen.dart';
import 'package:fit_well/screens/wera%20os/wear_signin_screen.dart';
import 'package:fit_well/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:fit_well/providers/theme_provider.dart';
import 'package:fit_well/providers/auth_provider.dart';
import 'package:fit_well/utils/theme.dart';
import 'package:is_wear/is_wear.dart';
import 'package:provider/provider.dart';

late final bool isWear;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    print("✅ Firebase initialized successfully");
  } catch (e) {
    print("❌ Firebase initialization failed: $e");
  }

  // try {
  //   await NotificationService.initialize();
  //   print("✅ NotificationService initialized");
  // } catch (e) {
  //   print("❌ NotificationService initialization failed: $e");
  // }

  // Check for Wear OS
  isWear = (await IsWear().check()) ?? false;
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  var userId;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => WatchProvider(themeProvider)),
        ChangeNotifierProvider(create: (_) => CalorieProvider()),
        ChangeNotifierProvider(create: (_) => WaterProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Fit Well",
          home: isWear
              ? context.watch<AuthProvider>().isLoggedIn
              ? const WearHomeScreen()
              : const WearSignInScreen()
              : SignInScreen(),
          themeMode: themeProvider.themeMode,
          theme: MyTheme.lightTheme(isWear: isWear),
          darkTheme: MyTheme.darkTheme(isWear: isWear),
        );
      },
    );
  }
}
