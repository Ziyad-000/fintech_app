import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notificationsList = [
      {
        'id': 1,
        'title': 'Payment Received',
        'desc': 'You received \$4,250.00 from Salary.',
        'time': '10m ago',
        'icon': LucideIcons.arrowDownLeft,
        'color': AppTheme.successColor,
        'bg': AppTheme.successColor.withValues(alpha: 0.1),
        'unread': true,
      },
      {
        'id': 2,
        'title': 'Transfer Sent',
        'desc': 'You sent \$50.00 to John Doe.',
        'time': '2h ago',
        'icon': LucideIcons.arrowUpRight,
        'color': AppTheme.primaryColor,
        'bg': AppTheme.primaryColor.withValues(alpha: 0.1),
        'unread': true,
      },
      {
        'id': 3,
        'title': 'Security Alert',
        'desc': 'New login detected on a Mac device.',
        'time': 'Yesterday',
        'icon': LucideIcons.shieldAlert,
        'color': AppTheme.warningColor,
        'bg': AppTheme.warningColor.withValues(alpha: 0.1),
        'unread': false,
      },
      {
        'id': 4,
        'title': 'Goal Reached',
        'desc': 'You have reached your savings goal!',
        'time': 'Oct 12',
        'icon': LucideIcons.checkCircle2,
        'color': const Color(0xFFA855F7), // Purple-500
        'bg': const Color(0xFFA855F7).withValues(alpha: 0.1),
        'unread': false,
      },
    ];

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
                    'Notifications',
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                physics: const BouncingScrollPhysics(),
                itemCount: notificationsList.length,
                itemBuilder: (context, index) {
                  final notif = notificationsList[index];
                  final bool isUnread = notif['unread'] as bool;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: isUnread
                          ? AppTheme.cardColor.withValues(alpha: 0.5)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isUnread
                            ? AppTheme.cardBorderColor.withValues(alpha: 0.5)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: notif['bg'] as Color,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            notif['icon'] as IconData,
                            color: notif['color'] as Color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    notif['title'] as String,
                                    style: TextStyle(
                                      color: isUnread
                                          ? Colors.white
                                          : AppTheme.textSecondaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    notif['time'] as String,
                                    style: const TextStyle(
                                      color: Color(0xFF64748B), // Slate-500
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif['desc'] as String,
                                style: const TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
