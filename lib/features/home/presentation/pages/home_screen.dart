import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fintech_app/models/transaction_model.dart';
import 'package:fintech_app/models/wallet_model.dart';
import 'package:fintech_app/widgets/transaction_tile.dart';
import 'package:fintech_app/widgets/wallet_card.dart';
import 'package:fintech_app/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data representing the models with exact fields
    const mockWallet = WalletModel(
      balance: 12450.00,
      currency: '\$',
      cardNumberLast4: '4289',
      cardExpiry: '12/28',
    );

    final mockTransactions = [
      TransactionModel(
        id: '1',
        title: 'Netflix Subscription',
        category: 'Entertainment',
        type: TransactionType.expense,
        amount: 15.99,
        date: DateTime.now(), // Today
        status: TransactionStatus.success,
        iconOrEmoji: 'N',
      ),
      TransactionModel(
        id: '2',
        title: 'Salary',
        category: 'Salary',
        type: TransactionType.income,
        amount: 4250.00,
        date: DateTime.now().subtract(const Duration(days: 1)), // Yesterday
        status: TransactionStatus.success,
        iconOrEmoji: 'S',
      ),
      TransactionModel(
        id: '3',
        title: 'Coffee Shop',
        category: 'Food',
        type: TransactionType.expense,
        amount: 4.50,
        date: DateTime.now().subtract(const Duration(days: 1)), // Yesterday
        status: TransactionStatus.success,
        iconOrEmoji: '☕',
      ),
      TransactionModel(
        id: '4',
        title: 'Transfer to John',
        category: 'Transfer',
        type: TransactionType.expense,
        amount: 50.00,
        date: DateTime.now().subtract(const Duration(days: 3)), // Oct 12
        status: TransactionStatus.success,
        iconOrEmoji: 'J',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.go('/main/profile'),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1E293B),
                              width: 2,
                            ),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good morning,',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Ziyad Sayed',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.push('/main/notifications'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            LucideIcons.bell,
                            color: Color(0xFFCBD5E1),
                            size: 20,
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppTheme.dangerColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.backgroundColor,
                                  width: 1.5,
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
              const SizedBox(height: 32),

              // Wallet Card
              WalletCard(wallet: mockWallet),
              const SizedBox(height: 32),

              // Quick Actions Row matching React
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickAction(
                    icon: LucideIcons.send,
                    label: 'Transfer',
                    color: const Color(0xFF3B82F6), // Blue
                    onTap: () => context.push('/main/transfer'),
                  ),
                  _buildQuickAction(
                    icon: LucideIcons.qrCode,
                    label: 'Pay',
                    color: const Color(0xFFA855F7), // Purple
                    onTap: () => context.push('/main/bills'),
                  ),
                  _buildQuickAction(
                    icon: LucideIcons.plus,
                    label: 'Top Up',
                    color: const Color(0xFF10B981), // Emerald
                    onTap: () => context.push('/main/topup'),
                  ),
                  _buildQuickAction(
                    icon: LucideIcons.history,
                    label: 'History',
                    color: const Color(0xFFF59E0B), // Amber
                    onTap: () => context.go('/main/transactions'),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Recent Transactions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/main/transactions'),
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: Color(0xFF60A5FA), // Blue-400
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Transactions List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mockTransactions.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final transaction = mockTransactions[index];
                  return TransactionTile(
                    transaction: transaction,
                    onTap: () => context.push(
                      '/main/transaction-details',
                      extra: transaction,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Icon(icon, color: color, size: 24)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
