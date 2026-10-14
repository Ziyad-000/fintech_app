import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fintech_app/models/transaction_model.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  String _formatDateTime(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final monthStr = months[date.month - 1];
    final dayStr = date.day.toString();
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minuteStr = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$monthStr $dayStr, $hour:$minuteStr $period';
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final formattedAmount = '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}';
    final formattedDate = _formatDateTime(transaction.date);

    Color statusBgColor;
    Color statusTextColor;
    String statusLabel;

    switch (transaction.status) {
      case TransactionStatus.success:
        statusBgColor = const Color(0xFF10B981).withValues(alpha: 0.1);
        statusTextColor = const Color(0xFF34D399);
        statusLabel = 'Completed';
        break;
      case TransactionStatus.pending:
        statusBgColor = const Color(0xFFF59E0B).withValues(alpha: 0.1);
        statusTextColor = const Color(0xFFFBBF24);
        statusLabel = 'Pending';
        break;
      case TransactionStatus.failed:
        statusBgColor = const Color(0xFFEF4444).withValues(alpha: 0.1);
        statusTextColor = const Color(0xFFF87171);
        statusLabel = 'Failed';
        break;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.chevronLeft, color: Colors.white, size: 28),
                    onPressed: () => context.pop(),
                  ),
                  const Text(
                    'Transaction Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.share2, color: Colors.white, size: 24),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Transaction details shared'),
                          backgroundColor: Color(0xFF1E293B),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Transaction Icon/Arrow
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isIncome
                            ? const Color(0xFF10B981).withValues(alpha: 0.2)
                            : const Color(0xFF3B82F6).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: isIncome
                                ? const Color(0xFF10B981).withValues(alpha: 0.1)
                                : const Color(0xFF3B82F6).withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        isIncome ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight,
                        color: isIncome ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Amount
                    Text(
                      formattedAmount,
                      style: TextStyle(
                        color: isIncome ? const Color(0xFF34D399) : Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      transaction.title,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Info Card
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                        border: Border.all(
                          color: const Color(0xFF334155).withValues(alpha: 0.5),
                        ),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Transaction Info',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Row items helper
                          _buildInfoRow('Status', Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                color: statusTextColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                          const SizedBox(height: 20),

                          _buildInfoRow('Date & Time', Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          const SizedBox(height: 20),

                          _buildInfoRow('Category', Text(
                            transaction.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          const SizedBox(height: 20),

                          _buildInfoRow('Reference', Text(
                            'FP-${transaction.id.toUpperCase()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Failed warning details
                    if (transaction.status == TransactionStatus.failed)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                          border: Border.all(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('⚠️ ', style: TextStyle(fontSize: 18)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Transaction Failed',
                                    style: TextStyle(
                                      color: Color(0xFFF87171),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'This transaction could not be processed. No funds were deducted.',
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Download receipt button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E293B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Receipt downloaded successfully'),
                              backgroundColor: Color(0xFF10B981),
                            ),
                          );
                        },
                        icon: const Icon(LucideIcons.download, color: Colors.white, size: 20),
                        label: const Text(
                          'Download Receipt',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

  Widget _buildInfoRow(String label, Widget valueWidget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 15,
          ),
        ),
        valueWidget,
      ],
    );
  }
}
