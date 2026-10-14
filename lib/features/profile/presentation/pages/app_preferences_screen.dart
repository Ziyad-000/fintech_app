import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../theme/app_theme.dart';

class AppPreferencesScreen extends StatefulWidget {
  const AppPreferencesScreen({super.key});

  @override
  State<AppPreferencesScreen> createState() => _AppPreferencesScreenState();
}

class _AppPreferencesScreenState extends State<AppPreferencesScreen> {
  bool _isDarkMode = true;
  bool _pushNotifications = true;
  bool _emailAlerts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.chevronLeft,
                        color: AppTheme.textSecondaryColor,
                        size: 24,
                      ),
                    ),
                  ),
                  const Text(
                    'App Preferences',
                    style: TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Appearance Section
                    _buildSectionHeader('Appearance'),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppTheme.cardBorderColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: _buildSwitchTile(
                        title: 'Dark Mode',
                        value: _isDarkMode,
                        icon: _isDarkMode ? LucideIcons.moon : LucideIcons.sun,
                        iconColor: const Color(0xFF818CF8), // Indigo-400
                        iconBgColor: const Color(0xFF818CF8).withValues(alpha: 0.1),
                        onChanged: (val) {
                          setState(() {
                            _isDarkMode = val;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Notifications Section
                    _buildSectionHeader('Notifications'),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppTheme.cardBorderColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildSwitchTile(
                            title: 'Push Notifications',
                            value: _pushNotifications,
                            icon: LucideIcons.bell,
                            iconColor: AppTheme.warningColor,
                            iconBgColor: AppTheme.warningColor.withValues(alpha: 0.1),
                            onChanged: (val) {
                              setState(() {
                                _pushNotifications = val;
                              });
                            },
                          ),
                          Divider(
                            color: AppTheme.cardBorderColor.withValues(alpha: 0.3),
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                          _buildSwitchTile(
                            title: 'Email Alerts',
                            value: _emailAlerts,
                            icon: LucideIcons.bell,
                            iconColor: AppTheme.primaryColor,
                            iconBgColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                            onChanged: (val) {
                              setState(() {
                                _emailAlerts = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Region & Language
                    _buildSectionHeader('Region & Language'),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppTheme.cardBorderColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            // Show language selection or simulate
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Language selection option'),
                                duration: Duration(milliseconds: 1000),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppTheme.successColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    LucideIcons.globe,
                                    color: AppTheme.successColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Language',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                const Text(
                                  'English (US)',
                                  style: TextStyle(
                                    color: AppTheme.textSecondaryColor,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  LucideIcons.chevronRight,
                                  color: AppTheme.textSecondaryColor,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.textSecondaryColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppTheme.primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
