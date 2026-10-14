import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fintech_app/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuGroups = [
      {
        'title': 'Account',
        'items': [
          {
            'icon': LucideIcons.user,
            'label': 'Personal Information',
            'color': const Color(0xFF3B82F6), // Blue-500
            'bg': const Color(0xFF3B82F6).withValues(alpha: 0.1),
            'path': '/main/profile/edit',
          },
          {
            'icon': LucideIcons.settings,
            'label': 'App Preferences',
            'color': const Color(0xFFA855F7), // Purple-500
            'bg': const Color(0xFFA855F7).withValues(alpha: 0.1),
            'path': '/main/profile/preferences',
          },
        ]
      },
      {
        'title': 'Security & Privacy',
        'items': [
          {
            'icon': LucideIcons.shield,
            'label': 'Security Settings',
            'color': const Color(0xFF10B981), // Emerald-500
            'bg': const Color(0xFF10B981).withValues(alpha: 0.1),
            'path': '/main/profile/security',
          },
        ]
      },
      {
        'title': 'General',
        'items': [
          {
            'icon': LucideIcons.bell,
            'label': 'Notifications',
            'color': const Color(0xFFF59E0B), // Amber-500
            'bg': const Color(0xFFF59E0B).withValues(alpha: 0.1),
            'path': '/main/notifications',
          },
          {
            'icon': LucideIcons.helpCircle,
            'label': 'Help Center',
            'color': const Color(0xFF94A3B8), // Slate-400
            'bg': const Color(0xFF1E293B), // Slate-800
            'path': '/main/help-center',
          },
        ]
      }
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // User Card Info
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.cardBorderColor.withValues(alpha: 0.8),
                          width: 4,
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=250&q=80',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Alex Mitchell',
                      style: TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'alex.mitchell@example.com',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Menu Sections
              Column(
                children: List.generate(menuGroups.length, (groupIdx) {
                  final group = menuGroups[groupIdx];
                  final items = group['items'] as List<Map<String, dynamic>>;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
                          child: Text(
                            (group['title'] as String).toUpperCase(),
                            style: const TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppTheme.cardBorderColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: List.generate(items.length, (itemIdx) {
                              final item = items[itemIdx];
                              return Column(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(itemIdx == 0 ? 24 : 0),
                                        topRight: Radius.circular(itemIdx == 0 ? 24 : 0),
                                        bottomLeft: Radius.circular(itemIdx == items.length - 1 ? 24 : 0),
                                        bottomRight: Radius.circular(itemIdx == items.length - 1 ? 24 : 0),
                                      ),
                                      onTap: () {
                                        final path = item['path'] as String;
                                        if (path != '#') {
                                          context.push(path);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: item['bg'] as Color,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                item['icon'] as IconData,
                                                color: item['color'] as Color,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Text(
                                              item['label'] as String,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Spacer(),
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
                                  if (itemIdx != items.length - 1)
                                    Divider(
                                      color: AppTheme.cardBorderColor.withValues(alpha: 0.3),
                                      height: 1,
                                      indent: 16,
                                      endIndent: 16,
                                    ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              // Logout Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => context.go('/auth/login'),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppTheme.dangerColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppTheme.dangerColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.dangerColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            LucideIcons.logOut,
                            color: AppTheme.dangerColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Log Out',
                          style: TextStyle(
                            color: AppTheme.dangerColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

