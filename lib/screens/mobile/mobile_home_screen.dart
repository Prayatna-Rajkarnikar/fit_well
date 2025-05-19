import 'package:fit_well/providers/theme_provider.dart';
import 'package:fit_well/providers/water_provider.dart';
import 'package:fit_well/screens/mobile/mobile_calories_screen.dart';
import 'package:fit_well/screens/mobile/mobile_report_screen.dart';
import 'package:fit_well/screens/mobile/mobile_set_timer_screen.dart';
import 'package:fit_well/screens/mobile/mobile_water_reminder_screen.dart';
import 'package:fit_well/screens/mobile/profile_screen.dart';
import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreenContent(userId: widget.userId),
      ReportScreen(),
      const ProfileScreen(),
    ];
  }

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ['Home', 'Report', 'Profile'][_currentIndex],
          style: theme.textTheme.headlineLarge,
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  final String userId;
  const HomeScreenContent({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ListView(
        children: [
          _buildCard(
            context,
            title: 'Calories Burned',
            icon: Icons.local_fire_department_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CaloriesScreen(calories: 0),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildCard(
            context,
            title: 'Water Log',
            icon: FontAwesomeIcons.droplet,
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                      create: (_) => WaterProvider(),
                      child: WaterReminderScreen(userId: userId),
                    ),
                  ),
                );
              });
            },
          ),
          const SizedBox(height: 20),
          _buildCard(
            context,
            title: 'Timer',
            icon: Icons.alarm_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SetTimerScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        void Function()? onTap,
      }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 180,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineLarge,
              ),
              Icon(icon, size: 36, color: themeProvider.isDarkMode? AppColors.myWhite : AppColors.myBlack ),
            ],
          ),
        ),
      ),
    );
  }
}
