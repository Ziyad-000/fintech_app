import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../theme/app_theme.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final List<Map<String, String>> _faqList = [
    {
      'question': 'How to reset my password?',
      'answer':
          'You can reset your password from the Login screen by tapping "Forgot Password?". Enter your registered email address and verify with the 4-digit OTP code sent to your inbox.',
    },
    {
      'question': 'What are the transfer limits?',
      'answer':
          'Standard verified accounts can send up to \$5,000 per day and \$25,000 per month. If you need higher limits, contact our support team.',
    },
    {
      'question': 'How to enable two-factor authentication?',
      'answer':
          'Go to Profile > Security Settings and switch on "Two-Factor Authentication". You will be asked to verify an SMS code for transactions.',
    },
    {
      'question': 'Why is my account blocked?',
      'answer':
          'Accounts may be temporarily restricted due to repeated incorrect password attempts or flagged suspicious activity. Contact live chat to verify your identity.',
    },
    {
      'question': 'How long do transfers take?',
      'answer':
          'Wallet-to-wallet transfers are completed instantly within seconds. External bank transfers typically take 1-2 business days.',
    },
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = _faqList
        .where((faq) =>
            faq['question']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            faq['answer']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

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
                    'Help Center',
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
                    // Search bar
                    TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search for help...',
                        prefixIcon: const Icon(
                          LucideIcons.search,
                          color: AppTheme.textSecondaryColor,
                          size: 20,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        fillColor: AppTheme.cardColor.withValues(alpha: 0.5),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: AppTheme.cardBorderColor.withValues(alpha: 0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: AppTheme.cardBorderColor.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                            color: AppTheme.primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Contact Options
                    _buildSectionHeader('Contact Us'),
                    Row(
                      children: [
                        Expanded(
                          child: _buildContactCard(
                            title: 'Live Chat',
                            icon: LucideIcons.messageCircle,
                            iconColor: AppTheme.primaryColor,
                            iconBgColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Starting Live Chat...')),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildContactCard(
                            title: 'Call Us',
                            icon: LucideIcons.phone,
                            iconColor: AppTheme.successColor,
                            iconBgColor: AppTheme.successColor.withValues(alpha: 0.1),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Calling customer support...')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // FAQ
                    _buildSectionHeader('Frequently Asked Questions'),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppTheme.cardBorderColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: filteredFaqs.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Center(
                                child: Text(
                                  'No FAQs found',
                                  style: TextStyle(color: AppTheme.textSecondaryColor),
                                ),
                              ),
                            )
                          : Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: Column(
                                children: List.generate(filteredFaqs.length, (index) {
                                  final faq = filteredFaqs[index];
                                  return Column(
                                    children: [
                                      ExpansionTile(
                                        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                        childrenPadding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                                        leading: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              LucideIcons.helpCircle,
                                              color: AppTheme.primaryColor,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                        iconColor: AppTheme.primaryColor,
                                        collapsedIconColor: AppTheme.textSecondaryColor,
                                        title: Text(
                                          faq['question'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              faq['answer'] ?? '',
                                              style: const TextStyle(
                                                color: AppTheme.textSecondaryColor,
                                                fontSize: 14,
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (index != filteredFaqs.length - 1)
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
      padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF64748B), // Slate-500
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return Container(
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
