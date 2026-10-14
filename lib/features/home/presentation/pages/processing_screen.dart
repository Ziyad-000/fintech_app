import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../theme/app_theme.dart';

class ProcessingScreen extends StatefulWidget {
  final Map<String, dynamic> payload;
  final String nextRoute;

  const ProcessingScreen({
    super.key,
    required this.payload,
    required this.nextRoute,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> with SingleTickerProviderStateMixin {
  String _status = "processing"; // "processing" | "success" | "failed"
  late AnimationController _rotationController;
  Timer? _delayTimer;
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _startProcessing();
  }

  void _startProcessing() {
    final randomDelay = 1500 + Random().nextInt(500);
    _delayTimer = Timer(Duration(milliseconds: randomDelay), () {
      if (!mounted) return;
      
      final succeeded = Random().nextDouble() > 0.15;
      if (succeeded) {
        setState(() {
          _status = "success";
        });
        _rotationController.stop();
        
        // Generate mock response details
        final updatedPayload = Map<String, dynamic>.from(widget.payload);
        updatedPayload['ref'] = _generateRef();
        updatedPayload['timestamp'] = _generateTimestamp();

        _redirectTimer = Timer(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          context.go(widget.nextRoute, extra: updatedPayload);
        });
      } else {
        setState(() {
          _status = "failed";
        });
        _rotationController.stop();
      }
    });
  }

  String _generateRef() {
    const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    final rand = Random();
    String result = "FP-";
    for (int i = 0; i < 8; i++) {
      result += chars[rand.nextInt(chars.length)];
    }
    return result;
  }

  String _generateTimestamp() {
    final now = DateTime.now();
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    final monthStr = months[now.month - 1];
    final dayStr = now.day.toString().padLeft(2, '0');
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minuteStr = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? "PM" : "AM";
    return "$monthStr $dayStr, ${now.year}, ${hour.toString().padLeft(2, '0')}:$minuteStr $ampm";
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _delayTimer?.cancel();
    _redirectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_status == "processing") ...[
                // Spinning Loader
                SizedBox(
                  width: 96,
                  height: 96,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer Border Track
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF1E293B),
                            width: 4,
                          ),
                        ),
                      ),
                      // Spinning Top Arc
                      RotationTransition(
                        turns: _rotationController,
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CircularProgressIndicator(
                            value: 0.25,
                            strokeWidth: 4,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                          ),
                        ),
                      ),
                      // Center Circle Icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        ),
                        child: Center(
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primaryColor.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Processing...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Please wait while we process your transaction.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Do not close this screen.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF64748B), // Slate 500
                    fontSize: 14,
                  ),
                ),
              ] else if (_status == "success") ...[
                // Success State
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
                  "Transaction Approved",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Redirecting you now...",
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 16,
                  ),
                ),
              ] else ...[
                // Failed State
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.dangerColor.withValues(alpha: 0.2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.dangerColor.withValues(alpha: 0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      LucideIcons.x,
                      color: AppTheme.dangerColor,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Transaction Failed",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "We could not process your payment.",
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "No funds were deducted from your account.",
                  style: TextStyle(
                    color: Color(0xFF64748B), // Slate 500
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),
                // CTAs
                ElevatedButton(
                  onPressed: () {
                    // Try again: go back to the entering amount / config screen (e.g. pop two screens)
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: const Text("Try Again"),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    context.go('/main/home');
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    foregroundColor: const Color(0xFFCBD5E1),
                    side: BorderSide.none,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
