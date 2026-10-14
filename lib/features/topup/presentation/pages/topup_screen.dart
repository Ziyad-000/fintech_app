import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../models/payment_method_model.dart';
import '../../../../theme/app_theme.dart';

class TopUpScreen extends StatefulWidget {
  final Map<String, dynamic>? initialPayload;

  const TopUpScreen({
    super.key,
    this.initialPayload,
  });

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  int _currentStep = 0; // 0: Select Amount, 1: Choose Method, 2: Review, 3: Success

  // State variables
  double _effectiveAmount = 0.0;
  int? _selectedPreset;
  bool _showCustom = false;
  String _customAmountText = "";

  PaymentMethodModel? _selectedMethod;

  String _ref = "";
  String _timestamp = "";

  // Mock preset amounts
  final List<int> _presets = const [10, 20, 50, 100, 200, 500];

  // Mock Payment Methods
  final List<PaymentMethodModel> _methods = const [
    PaymentMethodModel(id: "visa", label: "Visa Card", last4: "4289", type: PaymentMethodType.card, emoji: "💳"),
    PaymentMethodModel(id: "mastercard", label: "Mastercard", last4: "8821", type: PaymentMethodType.card, emoji: "💳"),
    PaymentMethodModel(id: "apple", label: "Apple Pay", last4: "", type: PaymentMethodType.wallet, emoji: "🍎"),
    PaymentMethodModel(id: "bank", label: "Bank Transfer", last4: "6612", type: PaymentMethodType.bank, emoji: "🏦"),
  ];

  @override
  void initState() {
    super.initState();
    _selectedMethod = _methods.first;

    // Handle return from processing screen
    if (widget.initialPayload != null) {
      final payload = widget.initialPayload!;
      if (payload.containsKey('ref')) {
        _ref = payload['ref'] ?? '';
        _timestamp = payload['timestamp'] ?? '';
        final amtStr = payload['amount'] ?? '0.0';
        _effectiveAmount = double.tryParse(amtStr) ?? 0.0;

        final methodData = payload['method'];
        if (methodData is PaymentMethodModel) {
          _selectedMethod = methodData;
        } else if (methodData is Map<String, dynamic>) {
          _selectedMethod = _methods.firstWhere((m) => m.id == methodData['id'], orElse: () => _methods.first);
        }
        _currentStep = 3; // Jump to Success
      }
    }
  }

  void _onBack() {
    if (_currentStep == 0) {
      context.pop();
    } else if (_currentStep == 3) {
      context.go('/main/home');
    } else {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _calculateEffectiveAmount() {
    if (_showCustom) {
      _effectiveAmount = double.tryParse(_customAmountText) ?? 0.0;
    } else {
      _effectiveAmount = (_selectedPreset ?? 0).toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _buildStepContent(),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildSelectAmount();
      case 1:
        return _buildChooseMethod();
      case 2:
        return _buildReviewTopUp();
      case 3:
        return _buildTopUpSuccess();
      default:
        return const SizedBox.shrink();
    }
  }

  // STEP 0: SELECT AMOUNT
  Widget _buildSelectAmount() {
    final isValid = _effectiveAmount > 0;

    return Column(
      key: const ValueKey(0),
      children: [
        // App Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _onBack,
                icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.6),
                  padding: const EdgeInsets.all(10),
                ),
              ),
              const Text(
                "Top Up Wallet",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              // Balance Preview Card
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xFF334155).withValues(alpha: 0.5)),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.successColor.withValues(alpha: 0.2),
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.wallet, color: AppTheme.successColor, size: 24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Current Balance", style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                        Text("\$12,450.00", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    if (isValid) ...[
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("After Top Up", style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                          Text(
                            "\$${(12450.0 + _effectiveAmount).toStringAsFixed(2)}",
                            style: const TextStyle(color: AppTheme.successColor, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ]
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Preset title
              const Text(
                "SELECT AMOUNT",
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // Presets Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                ),
                itemCount: _presets.length,
                itemBuilder: (context, idx) {
                  final amt = _presets[idx];
                  final isSelected = !_showCustom && _selectedPreset == amt;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _showCustom = false;
                        _selectedPreset = amt;
                        _calculateEffectiveAmount();
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor : const Color(0xFF1E293B).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "\$$amt",
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Custom amount toggle button
              InkWell(
                onTap: () {
                  setState(() {
                    _showCustom = true;
                    _selectedPreset = null;
                    _calculateEffectiveAmount();
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _showCustom ? AppTheme.primaryColor.withValues(alpha: 0.2) : const Color(0xFF1E293B).withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _showCustom ? AppTheme.primaryColor : const Color(0xFF334155).withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Enter Custom Amount",
                      style: TextStyle(
                        color: _showCustom ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // Custom input field
              if (_showCustom) ...[
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      const Text(
                        r"$",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          autofocus: true,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          onChanged: (val) {
                            setState(() {
                              _customAmountText = val;
                              _calculateEffectiveAmount();
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "0.00",
                            hintStyle: TextStyle(color: Color(0xFF475569)),
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        // Bottom Continue CTA
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ElevatedButton(
            onPressed: isValid
                ? () {
                    setState(() {
                      _currentStep = 1;
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isValid ? AppTheme.primaryColor : const Color(0xFF1E293B),
              foregroundColor: isValid ? Colors.white : const Color(0xFF475569),
              disabledBackgroundColor: const Color(0xFF1E293B),
            ),
            child: const Text("Continue"),
          ),
        ),
      ],
    );
  }

  // STEP 1: CHOOSE PAYMENT METHOD
  Widget _buildChooseMethod() {
    return Column(
      key: const ValueKey(1),
      children: [
        // App Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _onBack,
                icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.6),
                  padding: const EdgeInsets.all(10),
                ),
              ),
              const Text(
                "Payment Method",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              // Amount pill
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Text(
                    "Top Up: \$${_effectiveAmount.toStringAsFixed(2)}",
                    style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                "CHOOSE PAYMENT METHOD",
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // Payment methods list
              ..._methods.map((method) {
                final isSelected = _selectedMethod?.id == method.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedMethod = method;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryColor.withValues(alpha: 0.15)
                            : const Color(0xFF1E293B).withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.6) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF334155).withValues(alpha: 0.6),
                            ),
                            child: Center(
                              child: Text(method.emoji, style: const TextStyle(fontSize: 24)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method.label,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                                if (method.last4 != null && method.last4!.isNotEmpty)
                                  Text(
                                    "•••• ${method.last4}",
                                    style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppTheme.primaryColor : const Color(0xFF475569),
                                width: 2,
                              ),
                              color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Center(child: Icon(LucideIcons.check, color: Colors.white, size: 14))
                                : null,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Trust note
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("🔒", style: TextStyle(fontSize: 18)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Your payment information is encrypted and secured by FlowPay.",
                        style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),

        // Continue button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep = 2;
              });
            },
            child: const Text("Continue"),
          ),
        ),
      ],
    );
  }

  // STEP 2: REVIEW TOP UP
  Widget _buildReviewTopUp() {
    final balanceVal = 12450.0 + _effectiveAmount;

    return Column(
      key: const ValueKey(2),
      children: [
        // App Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _onBack,
                icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.6),
                  padding: const EdgeInsets.all(10),
                ),
              ),
              const Text(
                "Review Top Up",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              // Hero Display
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.successColor.withValues(alpha: 0.2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.successColor.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text("💳", style: TextStyle(fontSize: 36)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  "\$${_effectiveAmount.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  "Adding to your wallet",
                  style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 15),
                ),
              ),
              const SizedBox(height: 32),

              // Summary Card
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                  border: Border.all(color: const Color(0xFF334155).withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildSummaryRow("Top Up Amount", "\$${_effectiveAmount.toStringAsFixed(2)}", false),
                    const SizedBox(height: 20),
                    _buildSummaryRow(
                      "Payment Method",
                      _selectedMethod != null
                          ? "${_selectedMethod!.label}${_selectedMethod!.last4!.isNotEmpty ? ' ••••${_selectedMethod!.last4}' : ''}"
                          : "—",
                      false,
                    ),
                    const SizedBox(height: 20),
                    _buildSummaryRow("Processing Fee", "\$0.00", false),
                    const SizedBox(height: 20),
                    Container(
                      height: 1,
                      color: const Color(0xFF334155).withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 20),
                    _buildSummaryRow("New Balance", "\$${balanceVal.toStringAsFixed(2)}", true),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Protection message
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.05),
                  border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: const Row(
                  children: [
                    Icon(LucideIcons.shieldCheck, color: AppTheme.primaryColor, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Funds are added to your wallet instantly upon confirmation.",
                        style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        // Confirm top-up action
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ElevatedButton(
            onPressed: () {
              final payload = {
                'amount': _effectiveAmount.toString(),
                'method': _selectedMethod != null
                    ? {
                        'id': _selectedMethod!.id,
                        'label': _selectedMethod!.label,
                        'last4': _selectedMethod!.last4,
                      }
                    : null,
              };
              context.push(
                '/main/processing',
                extra: {
                  'payload': payload,
                  'nextRoute': '/main/topup/success',
                },
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.successColor),
            child: const Text("Confirm Top Up"),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isHighlight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isHighlight ? Colors.white : AppTheme.textSecondaryColor,
            fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
            fontSize: 15,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isHighlight ? AppTheme.successColor : Colors.white,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
            fontSize: isHighlight ? 20 : 15,
          ),
        ),
      ],
    );
  }

  // STEP 3: TOP UP SUCCESS
  Widget _buildTopUpSuccess() {
    final balanceVal = 12450.0 + _effectiveAmount;

    return Container(
      key: const ValueKey(3),
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.successColor.withValues(alpha: 0.2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.successColor.withValues(alpha: 0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      LucideIcons.check,
                      color: AppTheme.successColor,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                const Text(
                  "Top Up Successful!",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Your wallet has been topped up.",
                  style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 15),
                ),
                const SizedBox(height: 32),

                // New Balance Banner
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    border: Border.all(color: AppTheme.successColor.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    children: [
                      const Text("New Balance", style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        "\$${balanceVal.toStringAsFixed(2)}",
                        style: const TextStyle(color: AppTheme.successColor, fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Details Card
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withValues(alpha: 0.4),
                    border: Border.all(color: const Color(0xFF334155).withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Amount Added", style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14)),
                          Text("\$${_effectiveAmount.toStringAsFixed(2)}",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                        ],
                      ),
                      if (_selectedMethod != null) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("From", style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14)),
                            Text(
                              "${_selectedMethod!.label}${_selectedMethod!.last4!.isNotEmpty ? ' ••••${_selectedMethod!.last4}' : ''}",
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                      if (_timestamp.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Date", style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14)),
                            Text(_timestamp,
                                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Ref ID badge
                if (_ref.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Ref: ", style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                        Text(
                          _ref,
                          style: const TextStyle(color: Color(0xFFCBD5E1), fontFamily: "monospace", fontSize: 14),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // CTAs
          Column(
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _effectiveAmount = 0.0;
                    _selectedPreset = null;
                    _showCustom = false;
                    _customAmountText = "";
                    _currentStep = 0;
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white,
                  side: BorderSide.none,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.plus, size: 16),
                    SizedBox(width: 8),
                    Text(
                      "Top Up Again",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  context.go('/main/home');
                },
                child: const Text("Back to Home"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
