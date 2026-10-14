import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../models/contact_model.dart';
import '../../../../theme/app_theme.dart';

class TransferScreen extends StatefulWidget {
  final Map<String, dynamic>? initialPayload;

  const TransferScreen({
    super.key,
    this.initialPayload,
  });

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  int _currentStep = 0; // 0: Recipient, 1: Amount, 2: Note, 3: Review, 4: Success

  // State values
  ContactModel? _selectedRecipient;
  String _amount = "0";
  String _note = "";
  String _ref = "";
  String _timestamp = "";

  // Constant mock contacts (colors mapped to real Hex codes)
  final List<ContactModel> _contacts = const [
    ContactModel(id: "c1", name: "Sarah Johnson", handle: "@sarah.j", initials: "SJ", colorHex: "EC4899"),
    ContactModel(id: "c2", name: "Marcus Lee", handle: "@marcuslee", initials: "ML", colorHex: "3B82F6"),
    ContactModel(id: "c3", name: "Priya Nair", handle: "@priyanair", initials: "PN", colorHex: "8B5CF6"),
    ContactModel(id: "c4", name: "Tom Erikson", handle: "@tom.erik", initials: "TE", colorHex: "F59E0B"),
    ContactModel(id: "c5", name: "Yuki Tanaka", handle: "@yukitanaka", initials: "YT", colorHex: "10B981"),
    ContactModel(id: "c6", name: "Carlos Ruiz", handle: "@carlos_r", initials: "CR", colorHex: "F97316"),
    ContactModel(id: "c7", name: "Amara Osei", handle: "@amaraosei", initials: "AO", colorHex: "14B8A6"),
    ContactModel(id: "c8", name: "John Mitchell", handle: "@john.m", initials: "JM", colorHex: "06B6D4"),
  ];

  final List<String> _quickTags = const ["Rent", "Food", "Gift", "Personal", "Business", "Travel"];
  final List<String> _keypadKeys = const ["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "⌫"];

  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    // If we came back from processing screen as success
    if (widget.initialPayload != null) {
      final payload = widget.initialPayload!;
      if (payload.containsKey('ref')) {
        _ref = payload['ref'] ?? '';
        _timestamp = payload['timestamp'] ?? '';
        _amount = payload['amount'] ?? '0';
        _note = payload['note'] ?? '';
        final recipientData = payload['recipient'];
        if (recipientData is ContactModel) {
          _selectedRecipient = recipientData;
        } else if (recipientData is Map<String, dynamic>) {
          _selectedRecipient = ContactModel(
            id: recipientData['id'],
            name: recipientData['name'],
            handle: recipientData['handle'],
            initials: recipientData['initials'],
            colorHex: recipientData['colorHex'],
          );
        }
        _currentStep = 4; // Skip to Success Step
      }
    }
  }

  Color _getContactColor(String hex) {
    return Color(int.parse("FF$hex", radix: 16));
  }

  void _onBack() {
    if (_currentStep == 0) {
      context.pop();
    } else if (_currentStep == 4) {
      context.go('/main/home');
    } else {
      setState(() {
        _currentStep--;
      });
    }
  }

  // KEYPAD LOGIC
  void _handleKey(String key) {
    if (key == "⌫") {
      setState(() {
        _amount = _amount.length > 1 ? _amount.substring(0, _amount.length - 1) : "0";
      });
      return;
    }
    if (key == "." && _amount.contains(".")) return;
    if (_amount == "0" && key != ".") {
      setState(() {
        _amount = key;
      });
    } else {
      final next = _amount + key;
      final parts = next.split(".");
      if (parts.length > 1 && parts[1].length > 2) return;
      if (next.replaceAll(".", "").length > 9) return;
      setState(() {
        _amount = next;
      });
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
        return _buildSelectRecipient();
      case 1:
        return _buildEnterAmount();
      case 2:
        return _buildAddNote();
      case 3:
        return _buildReviewTransfer();
      case 4:
        return _buildTransferSuccess();
      default:
        return const SizedBox.shrink();
    }
  }

  // STEP 0: SELECT RECIPIENT
  Widget _buildSelectRecipient() {
    final filteredContacts = _contacts.where((c) {
      final query = _searchQuery.toLowerCase();
      return c.name.toLowerCase().contains(query) || c.handle.toLowerCase().contains(query);
    }).toList();

    final recents = _contacts.take(4).toList();

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
                "Send Money",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(LucideIcons.userPlus, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B).withValues(alpha: 0.6),
                  padding: const EdgeInsets.all(10),
                ),
              ),
            ],
          ),
        ),

        // Search Bar & Scrollable Content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              // Search Input
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(LucideIcons.search, color: AppTheme.textSecondaryColor, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: "Search by name or handle...",
                          hintStyle: TextStyle(color: AppTheme.textSecondaryColor),
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Contacts
              if (_searchQuery.isEmpty) ...[
                const Text(
                  "RECENT",
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recents.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 20),
                    itemBuilder: (context, idx) {
                      final c = recents[idx];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedRecipient = c;
                            _currentStep = 1;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getContactColor(c.colorHex),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getContactColor(c.colorHex).withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  c.initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 56,
                              child: Text(
                                c.name.split(" ")[0],
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // All Contacts Header
              Text(
                _searchQuery.isEmpty ? "ALL CONTACTS" : "RESULTS",
                style: const TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // Contacts List
              if (filteredContacts.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      "No contacts found",
                      style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
                    ),
                  ),
                )
              else
                ...filteredContacts.map((c) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _selectedRecipient = c;
                          _currentStep = 1;
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      hoverColor: const Color(0xFF1E293B).withValues(alpha: 0.6),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getContactColor(c.colorHex),
                        ),
                        child: Center(
                          child: Text(
                            c.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        c.name,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        c.handle,
                        style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
                      ),
                      trailing: const Icon(LucideIcons.chevronRight, color: Color(0xFF475569), size: 18),
                    ),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 1: ENTER AMOUNT
  Widget _buildEnterAmount() {
    final double numericVal = double.tryParse(_amount) ?? 0.0;
    final bool isValid = numericVal > 0;

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
                "Enter Amount",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),

        // Recipient Pill
        if (_selectedRecipient != null) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getContactColor(_selectedRecipient!.colorHex),
                ),
                child: Center(
                  child: Text(
                    _selectedRecipient!.initials,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedRecipient!.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  Text(
                    _selectedRecipient!.handle,
                    style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        ],

        // Amount Display (Centered)
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Amount to send",
                style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    r"$",
                    style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    child: Text(
                      _amount,
                      key: ValueKey(_amount),
                      style: TextStyle(
                        color: isValid ? Colors.white : const Color(0xFF475569),
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Available: \$12,450.00",
                style: TextStyle(color: Color(0xFF475569), fontSize: 12),
              ),
            ],
          ),
        ),

        // Keypad & Continue Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _keypadKeys.length,
                itemBuilder: (context, idx) {
                  final key = _keypadKeys[idx];
                  final isBackspace = key == "⌫";

                  return InkWell(
                    onTap: () => _handleKey(key),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isBackspace
                            ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                            : const Color(0xFF1E293B).withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: isBackspace
                            ? const Icon(LucideIcons.delete, color: AppTheme.textSecondaryColor, size: 20)
                            : Text(
                                key,
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isValid
                    ? () {
                        setState(() {
                          _currentStep = 2;
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
            ],
          ),
        ),
      ],
    );
  }

  // STEP 2: ADD NOTE
  Widget _buildAddNote() {
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
                "Add a Note",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _note = "";
                    _currentStep = 3;
                  });
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              // Summary Banner
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (_selectedRecipient != null)
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getContactColor(_selectedRecipient!.colorHex),
                            ),
                            child: Center(
                              child: Text(
                                _selectedRecipient!.initials,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Sending to", style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                            Text(_selectedRecipient?.name ?? "Recipient",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("Amount", style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                        Text("\$$_amount",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Text Field Label
              const Text(
                "WHAT'S IT FOR?",
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              // Note Input Field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      maxLines: 4,
                      maxLength: 120,
                      onChanged: (val) {
                        setState(() {
                          _note = val;
                        });
                      },
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: _note,
                          selection: TextSelection.collapsed(offset: _note.length),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: "Add a note (optional)...",
                        hintStyle: TextStyle(color: Color(0xFF475569)),
                        filled: false,
                        counterText: "",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${_note.length}/120",
                      style: const TextStyle(color: Color(0xFF475569), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Tags
              const Text(
                "QUICK TAGS",
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickTags.map((tag) {
                  final isSelected = _note == tag;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _note = tag;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor : const Color(0xFF1E293B).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // Bottom CTA
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep = 3;
              });
            },
            child: const Text("Continue"),
          ),
        ),
      ],
    );
  }

  // STEP 3: REVIEW TRANSFER
  Widget _buildReviewTransfer() {
    final double numericVal = double.tryParse(_amount) ?? 0.0;
    final totalStr = numericVal.toStringAsFixed(2);

    return Column(
      key: const ValueKey(3),
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
                "Review Transfer",
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
              // Hero Info
              const SizedBox(height: 16),
              if (_selectedRecipient != null) ...[
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getContactColor(_selectedRecipient!.colorHex),
                      boxShadow: [
                        BoxShadow(
                          color: _getContactColor(_selectedRecipient!.colorHex).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _selectedRecipient!.initials,
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Center(
                child: Text(
                  "\$$totalStr",
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  "to ${_selectedRecipient?.name ?? 'Recipient'}",
                  style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 15),
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
                    _buildReviewRow("To", _selectedRecipient?.name ?? "—"),
                    const SizedBox(height: 20),
                    _buildReviewRow("Handle", _selectedRecipient?.handle ?? "—"),
                    const SizedBox(height: 20),
                    _buildReviewRow("Amount", "\$$totalStr"),
                    const SizedBox(height: 20),
                    _buildReviewRow("Fee", "\$0.00"),
                    const SizedBox(height: 20),
                    _buildReviewRow("Arrival", "Instant"),
                    if (_note.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildReviewRow("Note", _note),
                    ],
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
                          "\$$totalStr",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Shield Secure Badge
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
                        "Protected by FlowPay Secure Transfer. Funds arrive instantly.",
                        style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        // Confirm Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to shared processing screen
              final payload = {
                'recipient': {
                  'id': _selectedRecipient?.id,
                  'name': _selectedRecipient?.name,
                  'handle': _selectedRecipient?.handle,
                  'initials': _selectedRecipient?.initials,
                  'colorHex': _selectedRecipient?.colorHex,
                },
                'amount': _amount,
                'note': _note,
              };
              context.push(
                '/main/processing',
                extra: {
                  'payload': payload,
                  'nextRoute': '/main/transfer/success',
                },
              );
            },
            child: const Text("Confirm & Send"),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value) {
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

  // STEP 4: TRANSFER SUCCESS
  Widget _buildTransferSuccess() {
    final double numericVal = double.tryParse(_amount) ?? 0.0;
    final totalStr = numericVal.toStringAsFixed(2);

    return Container(
      key: const ValueKey(4),
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

                // Main confirmation
                const Text(
                  "Transfer Successful!",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "\$$totalStr sent to ${_selectedRecipient?.name ?? 'recipient'}",
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
                      _buildReceiptRow("To", _selectedRecipient?.name ?? "—"),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Amount", style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14)),
                          Text("\$$totalStr",
                              style: const TextStyle(color: AppTheme.successColor, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      if (_note.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildReceiptRow("Note", _note),
                      ],
                      if (_timestamp.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildReceiptRow("Date", _timestamp),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Reference Badge
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
                    _amount = "0";
                    _note = "";
                    _selectedRecipient = null;
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
                    Icon(LucideIcons.send, size: 16),
                    SizedBox(width: 8),
                    Text(
                      "Send Again",
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
