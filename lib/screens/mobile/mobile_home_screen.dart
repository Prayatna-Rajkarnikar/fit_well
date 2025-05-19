import 'package:fit_well/providers/theme_provider.dart';
import 'package:fit_well/providers/water_provider.dart';
import 'package:fit_well/screens/mobile/mobile_calories_screen.dart';
import 'package:fit_well/screens/mobile/mobile_report_screen.dart';
import 'package:fit_well/screens/mobile/mobile_set_timer_screen.dart';
import 'package:fit_well/screens/mobile/mobile_water_reminder_screen.dart';
import 'package:fit_well/screens/mobile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();

    _screens.addAll([
      HomeScreenContent(userId: widget.userId),
      ReportScreen(),
      const ProfileScreen(),
    ]);
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ['Fit well', 'Report', 'Profile'][_currentIndex],
          style: theme.textTheme.headlineSmall,
        ),
        elevation: 1,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: _onTap,
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  final String userId;
  const HomeScreenContent({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

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
                  builder: (context) => CaloriesScreen(calories: 0),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildCard(
            context,
            title: 'Water Log',
            icon: FontAwesomeIcons.droplet,
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ChangeNotifierProvider(
                          create: (_) => WaterProvider(),
                          child: WaterReminderScreen(userId: userId),
                        ),
                  ),
                );
              });
            },
          ),
          const SizedBox(height: 12),
          _buildCard(
            context,
            title: 'Timer',
            icon: Icons.alarm_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SetTimerScreen()),
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
    final theme = Theme.of(context);
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
              Text(title, style: theme.textTheme.headlineSmall),
              Icon(icon, size: 36, color: theme.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
