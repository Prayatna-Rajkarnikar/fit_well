import 'package:fit_well/providers/auth_provider.dart';
import 'package:fit_well/providers/theme_provider.dart';
import 'package:fit_well/utils/custom_themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(

        actions: [
          IconButton(
            icon:  Icon(Icons.settings, color: themeProvider.isDarkMode ? AppColors.myWhite : AppColors.myBlack),
            onPressed: () {
              _showSettingsDialog(context, themeProvider);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.myGreen,
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: AppColors.myWhite,
                ),
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: Text(
                user?.name ?? 'No Name',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),

            Center(
              child: Text(
                user?.email ?? 'No Email',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),

            _buildLabel("Full Name", context),
            _buildInfoBox(user?.name ?? 'No Name', context),

            const SizedBox(height: 16),

            _buildLabel("Email", context),
            _buildInfoBox(user?.email ?? 'No Email', context),

            const SizedBox(height: 16),

            _buildLabel("Weight (kg)", context),
            _buildInfoBox(user?.weightKg.toString() ?? 'Not Available', context),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label, BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: themeProvider.isDarkMode? AppColors.myWhite : AppColors.myBlack),
    );
  }

  Widget _buildInfoBox(String text,BuildContext context ) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? AppColors.myGray : AppColors.myLightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: TextStyle(color: themeProvider.isDarkMode ? AppColors.myWhite : AppColors.myBlack)),
    );
  }

  void _showSettingsDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor:
                themeProvider.isDarkMode
                    ? AppColors.myGray
                    : AppColors.myLightGray,

            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Change theme',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    final icon =
                        themeProvider.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode;
                    return IconButton(
                      icon: Icon(icon, size: 24),
                      onPressed: () {
                        themeProvider.toggleTheme(!themeProvider.isDarkMode);
                      },
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
    );
  }
}
