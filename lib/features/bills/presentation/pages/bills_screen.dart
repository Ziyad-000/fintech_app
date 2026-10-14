import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../models/bill_service_model.dart';
import '../../../../theme/app_theme.dart';

class BillsScreen extends StatefulWidget {
  final Map<String, dynamic>? initialPayload;

  const BillsScreen({
    super.key,
    this.initialPayload,
  });

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  int _currentStep = 0; // 0: Select Service, 1: Enter Details, 2: Review, 3: Success

  BillServiceModel? _selectedService;
  final Map<String, TextEditingController> _fieldControllers = {};
  final TextEditingController _amountController = TextEditingController();

  // Submission info for review/success
  String _ref = "";
  String _timestamp = "";
  Map<String, String> _submittedDetails = {};
  String _submittedAmount = "";

  @override
  void initState() {
    super.initState();
    // Handle return from processing screen
    if (widget.initialPayload != null) {
      final payload = widget.initialPayload!;
      if (payload.containsKey('ref')) {
        _ref = payload['ref'] ?? '';
        _timestamp = payload['timestamp'] ?? '';
        _submittedAmount = payload['amount'] ?? '0';
        
        final detailsMap = payload['details'];
        if (detailsMap is Map) {
          _submittedDetails = Map<String, String>.from(detailsMap);
        }

        final serviceData = payload['service'];
        if (serviceData is BillServiceModel) {
          _selectedService = serviceData;
        } else if (serviceData is Map<String, dynamic>) {
          _selectedService = mockBillServices.firstWhere(
            (s) => s.id == serviceData['id'],
            orElse: () => mockBillServices.first,
          );
        }
        _currentStep = 3; // Skip to Success Step
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _fieldControllers.values) {
      controller.dispose();
    }
    _amountController.dispose();
    super.dispose();
  }

  Color _getServiceColor(String id) {
    switch (id) {
      case 'internet':
        return Colors.blue;
      case 'electricity':
        return Colors.amber;
      case 'mobile':
        return const Color(0xFF10B981); // Emerald
      case 'water':
        return Colors.cyan;
      case 'tv':
        return Colors.purple;
      case 'insurance':
        return const Color(0xFFF43F5E); // Rose
      default:
        return Colors.blue;
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

  bool _isFormValid() {
    if (_selectedService == null) return false;
    for (var field in _selectedService!.fields) {
      final text = _fieldControllers[field.key]?.text.trim() ?? "";
      if (text.isEmpty) return false;
    }
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) return false;
    final parsed = double.tryParse(amountText);
    if (parsed == null || parsed <= 0) return false;
    return true;
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
        return _buildSelectService();
      case 1:
        return _buildEnterDetails();
      case 2:
        return _buildReviewPayment();
      case 3:
        return _buildPaymentSuccess();
      default:
        return const SizedBox.shrink();
    }
  }

  // STEP 0: SELECT SERVICE
  Widget _buildSelectService() {
    return Container(
      key: const ValueKey(0),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _onBack,
                  icon: const Icon(LucideIcons.chevronLeft, color: AppTheme.textPrimaryColor),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.cardColor.withValues(alpha: 0.6),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                const Text(
                  "Pay Bills",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 48), // Spacer for centering
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select a service to pay your bill quickly and securely.",
                    style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "AVAILABLE SERVICES",
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: mockBillServices.length,
                    itemBuilder: (context, index) {
                      final service = mockBillServices[index];
                      final color = _getServiceColor(service.id);
                      
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedService = service;
                            // Initialize controllers
                            _fieldControllers.clear();
                            for (var field in service.fields) {
                              _fieldControllers[field.key] = TextEditingController();
                            }
                            _amountController.clear();
                            _currentStep = 1;
                          });
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor.withValues(alpha: 0.4),
                            border: Border.all(color: AppTheme.cardBorderColor.withValues(alpha: 0.4)),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    service.emoji,
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                service.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Info Box
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("💡", style: TextStyle(fontSize: 18)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Bills are paid instantly. Keep your reference number for confirmation.",
                            style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // STEP 1: ENTER DETAILS
  Widget _buildEnterDetails() {
    if (_selectedService == null) return const SizedBox.shrink();
    final color = _getServiceColor(_selectedService!.id);
    
    return Container(
      key: const ValueKey(1),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _onBack,
                  icon: const Icon(LucideIcons.chevronLeft, color: AppTheme.textPrimaryColor),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.cardColor.withValues(alpha: 0.6),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                Text(
                  _selectedService!.name,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 48), // Spacer for centering
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Badge Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.cardBorderColor.withValues(alpha: 0.4)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              _selectedService!.emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedService!.name,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Enter your billing details below",
                                style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Dynamic Form Fields
                  ..._selectedService!.fields.map((field) {
                    final controller = _fieldControllers[field.key];
                    final isNumber = field.type == 'number';
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            field.label.toUpperCase(),
                            style: const TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: controller,
                            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                            decoration: InputDecoration(
                              hintText: field.placeholder,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  
                  // Amount Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "AMOUNT TO PAY",
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 20, right: 8),
                            child: Text(
                              "\$",
                              style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                          hintText: "0.00",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Action Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: _isFormValid()
                  ? () {
                      setState(() {
                        _submittedDetails.clear();
                        for (var field in _selectedService!.fields) {
                          _submittedDetails[field.key] = _fieldControllers[field.key]?.text.trim() ?? "";
                        }
                        _submittedAmount = _amountController.text.trim();
                        _currentStep = 2; // Go to Review
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid() ? AppTheme.primaryColor : const Color(0xFF1E293B),
                foregroundColor: _isFormValid() ? Colors.white : const Color(0xFF64748B),
              ),
              child: const Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }

  // STEP 2: REVIEW PAYMENT
  Widget _buildReviewPayment() {
    if (_selectedService == null) return const SizedBox.shrink();
    final double amountVal = double.tryParse(_submittedAmount) ?? 0.0;
    final amountStr = amountVal.toStringAsFixed(2);
    final color = _getServiceColor(_selectedService!.id);
    
    return Container(
      key: const ValueKey(2),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _onBack,
                  icon: const Icon(LucideIcons.chevronLeft, color: AppTheme.textPrimaryColor),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.cardColor.withValues(alpha: 0.6),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                const Text(
                  "Review Payment",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 48), // Spacer for centering
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Hero Area
                  const SizedBox(height: 24),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _selectedService!.emoji,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "\$$amountStr",
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedService!.name,
                    style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 15),
                  ),
                  const SizedBox(height: 32),
                  
                  // Summary Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor.withValues(alpha: 0.5),
                      border: Border.all(color: AppTheme.cardBorderColor.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        ..._selectedService!.fields.map((field) {
                          final value = _submittedDetails[field.key] ?? "—";
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _buildSummaryRow(field.label, value),
                          );
                        }),
                        _buildSummaryRow("Amount", "\$$amountStr"),
                        const SizedBox(height: 20),
                        _buildSummaryRow("Processing Fee", "\$0.00"),
                        const SizedBox(height: 20),
                        Container(
                          height: 1,
                          color: const Color(0xFF334155).withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              "\$$amountStr",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Secure Badge
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
                            "Payment is processed instantly and securely through FlowPay.",
                            style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Action Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Processing screen
                final payload = {
                  'service': {
                    'id': _selectedService!.id,
                    'name': _selectedService!.name,
                    'emoji': _selectedService!.emoji,
                    'colorTheme': _selectedService!.colorTheme,
                  },
                  'details': _submittedDetails,
                  'amount': _submittedAmount,
                };
                context.push(
                  '/main/processing',
                  extra: {
                    'payload': payload,
                    'nextRoute': '/main/bills/success',
                  },
                );
              },
              child: const Text("Confirm Payment"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 15)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      ],
    );
  }

  // STEP 3: SUCCESS
  Widget _buildPaymentSuccess() {
    if (_selectedService == null) return const SizedBox.shrink();
    final double amountVal = double.tryParse(_submittedAmount) ?? 0.0;
    final amountStr = amountVal.toStringAsFixed(2);
    
    final firstField = _selectedService!.fields.isNotEmpty ? _selectedService!.fields[0] : null;
    final firstFieldValue = firstField != null ? _submittedDetails[firstField.key] : null;

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
                // Success Badge
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
                
                // Text Confirmation
                const Text(
                  "Payment Successful!",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "${_selectedService!.name} paid successfully.",
                  style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 15),
                ),
                const SizedBox(height: 32),
                
                // Receipt details card
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
                          const Text("Service", style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14)),
                          Row(
                            children: [
                              Text(_selectedService!.emoji, style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(_selectedService!.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                      if (firstField != null && firstFieldValue != null) ...[
                        const SizedBox(height: 16),
                        _buildReceiptRow(firstField.label, firstFieldValue),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Amount Paid", style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14)),
                          Text("\$$amountStr",
                              style: const TextStyle(color: AppTheme.successColor, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      if (_timestamp.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildReceiptRow("Date", _timestamp),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Ref badge
                if (_ref.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Ref: ", style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                        Text(
                          _ref,
                          style: const TextStyle(color: Colors.white, fontFamily: "monospace", fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // Action Buttons
          Column(
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedService = null;
                    _fieldControllers.clear();
                    _amountController.clear();
                    _currentStep = 0;
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  side: const BorderSide(color: AppTheme.cardBorderColor),
                  foregroundColor: Colors.white,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.receipt, size: 18),
                    SizedBox(width: 8),
                    Text("Pay Another Bill", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
      ],
    );
  }
}
