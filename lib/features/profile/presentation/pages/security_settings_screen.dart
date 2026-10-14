import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../theme/app_theme.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _biometricsEnabled = true;
  bool _twoFactorEnabled = true;
  bool _screenLockEnabled = false;

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
                    'Security Settings',
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
                    _buildSectionHeader('Biometrics & Auth'),
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
                            title: 'Face ID / Fingerprint',
                            subtitle: 'Use biometrics to log in and approve transactions',
                            value: _biometricsEnabled,
                            icon: LucideIcons.fingerprint,
                            iconColor: const Color(0xFF10B981),
                            iconBgColor: const Color(0xFF10B981).withValues(alpha: 0.1),
                            onChanged: (val) {
                              setState(() => _biometricsEnabled = val);
                            },
                          ),
                          Divider(
                            color: AppTheme.cardBorderColor.withValues(alpha: 0.3),
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                          _buildSwitchTile(
                            title: 'Two-Factor Authentication',
                            subtitle: 'Require an OTP code for high-value transfers',
                            value: _twoFactorEnabled,
                            icon: LucideIcons.shieldCheck,
                            iconColor: const Color(0xFF3B82F6),
                            iconBgColor: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                            onChanged: (val) {
                              setState(() => _twoFactorEnabled = val);
                            },
                          ),
                          Divider(
                            color: AppTheme.cardBorderColor.withValues(alpha: 0.3),
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                          _buildSwitchTile(
                            title: 'Auto App Lock',
                            subtitle: 'Lock application immediately when minimized',
                            value: _screenLockEnabled,
                            icon: LucideIcons.lock,
                            iconColor: const Color(0xFFF59E0B),
                            iconBgColor: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                            onChanged: (val) {
                              setState(() => _screenLockEnabled = val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    _buildSectionHeader('Credentials'),
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
                          _buildNavigationTile(
                            title: 'Change Passcode / PIN',
                            subtitle: 'Update your 6-digit transaction PIN',
                            icon: LucideIcons.keyRound,
                            iconColor: const Color(0xFFA855F7),
                            iconBgColor: const Color(0xFFA855F7).withValues(alpha: 0.1),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('PIN Change dialog requested'),
                                  backgroundColor: AppTheme.cardColor,
                                ),
                              );
                            },
                          ),
                          Divider(
                            color: AppTheme.cardBorderColor.withValues(alpha: 0.3),
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                          _buildNavigationTile(
                            title: 'Change Password',
                            subtitle: 'Last updated 3 months ago',
                            icon: LucideIcons.lock,
                            iconColor: const Color(0xFF38BDF8),
                            iconBgColor: const Color(0xFF38BDF8).withValues(alpha: 0.1),
                            onTap: () {
                              context.push('/auth/forgot-password');
                            },
                          ),
                        ],
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
    required String subtitle,
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
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
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
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                color: AppTheme.textSecondaryColor,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
