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
      backgroundColor: AppColors.myBlack,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.myBlack,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.myWhite),
            onPressed: () {
              _showSettingsDialog(context, themeProvider);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.myGreen.withOpacity(0.2),
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: AppColors.myGreen,
                ),
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: Text(
                user?.name ?? 'No Name',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: AppColors.myWhite),
              ),
            ),
            const SizedBox(height: 8),

            Center(
              child: Text(
                user?.email ?? 'No Email',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.myLightGray),
              ),
            ),
            const SizedBox(height: 24),

            _buildLabel("Full Name", context),
            _buildInfoBox(user?.name ?? 'No Name'),

            const SizedBox(height: 16),

            _buildLabel("Email", context),
            _buildInfoBox(user?.email ?? 'No Email'),

            const SizedBox(height: 16),

            _buildLabel("Weight (kg)", context),
            _buildInfoBox(user?.weightKg.toString() ?? 'Not Available'),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label, BuildContext context) {
    return Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppColors.myWhite),
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.myGray.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.myWhite)),
    );
  }

  void _showSettingsDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.myBlack,
            title: const Text(
              'Settings',
              style: TextStyle(color: AppColors.myWhite),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dark Theme',
                  style: TextStyle(color: AppColors.myWhite),
                ),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {},
                  activeColor: AppColors.myGreen,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(color: AppColors.myWhite),
                ),
              ),
            ],
          ),
    );
  }
}
