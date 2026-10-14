import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fintech_app/models/transaction_model.dart';
import 'package:fintech_app/widgets/transaction_tile.dart';
import 'package:fintech_app/theme/app_theme.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Income', 'Expense', 'Shopping', 'Bills'];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<TransactionModel> _mockTransactions = [
    TransactionModel(
      id: 't1',
      title: 'Apple Store Purchase',
      category: 'Shopping',
      type: TransactionType.expense,
      amount: 999.00,
      date: DateTime.now(),
      status: TransactionStatus.success,
      iconOrEmoji: 'A',
    ),
    TransactionModel(
      id: 't2',
      title: 'Monthly Salary',
      category: 'Salary',
      type: TransactionType.income,
      amount: 4500.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: TransactionStatus.success,
      iconOrEmoji: 'S',
    ),
    TransactionModel(
      id: 't3',
      title: 'Netflix Subscription',
      category: 'Entertainment',
      type: TransactionType.expense,
      amount: 15.49,
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: TransactionStatus.success,
      iconOrEmoji: 'N',
    ),
    TransactionModel(
      id: 't4',
      title: 'Electricity Bill',
      category: 'Bills',
      type: TransactionType.expense,
      amount: 120.50,
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: TransactionStatus.success,
      iconOrEmoji: 'E',
    ),
    TransactionModel(
      id: 't5',
      title: 'Freelance Design Work',
      category: 'Salary',
      type: TransactionType.income,
      amount: 850.00,
      date: DateTime.now().subtract(const Duration(days: 7)),
      status: TransactionStatus.success,
      iconOrEmoji: 'F',
    ),
  ];

  List<TransactionModel> get _filteredTransactions {
    List<TransactionModel> list = _mockTransactions;
    if (_selectedFilter == 'Income') {
      list = list.where((t) => t.type == TransactionType.income).toList();
    } else if (_selectedFilter == 'Expense') {
      list = list.where((t) => t.type == TransactionType.expense).toList();
    } else if (_selectedFilter != 'All') {
      list = list.where((t) => t.category.toLowerCase() == _selectedFilter.toLowerCase()).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      list = list.where((t) {
        final matchesTitle = t.title.toLowerCase().contains(query);
        final matchesCategory = t.category.toLowerCase().contains(query);
        final matchesAmount = t.amount.toString().contains(query);
        return matchesTitle || matchesCategory || matchesAmount;
      }).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final listToDisplay = _filteredTransactions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search transactions...',
                  prefixIcon: const Icon(LucideIcons.search, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(LucideIcons.x, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            LucideIcons.sliders,
                            size: 16,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                ),
              ),
            ),

            // Filters Horizontal Scroll
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12.0),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor : AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : AppTheme.cardBorderColor.withValues(alpha: 0.5),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? AppTheme.textPrimaryColor : AppTheme.textSecondaryColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Transactions List
            Expanded(
              child: listToDisplay.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.ban,
                            size: 48,
                            color: AppTheme.textSecondaryColor.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No transactions found',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      itemCount: listToDisplay.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final transaction = listToDisplay[index];
                        return TransactionTile(
                          transaction: transaction,
                          onTap: () => context.push('/main/transaction-details', extra: transaction),
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
