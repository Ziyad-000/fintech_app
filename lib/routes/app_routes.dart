import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import screens
import '../features/splash/presentation/pages/splash_screen.dart';
import '../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/register_screen.dart';
import '../features/auth/presentation/pages/forgot_password_screen.dart';
import '../features/auth/presentation/pages/otp_screen.dart';
import '../features/auth/presentation/pages/new_password_screen.dart';
import '../features/home/presentation/pages/main_shell.dart';
import '../features/home/presentation/pages/home_screen.dart';
import '../features/transactions/presentation/pages/transactions_screen.dart';
import '../features/transactions/presentation/pages/transaction_details_screen.dart';
import '../features/statistics/presentation/pages/statistics_screen.dart';
import '../features/profile/presentation/pages/profile_screen.dart';
import '../features/profile/presentation/pages/edit_profile_screen.dart';
import '../features/profile/presentation/pages/app_preferences_screen.dart';
import '../features/profile/presentation/pages/notifications_screen.dart';
import '../features/profile/presentation/pages/help_center_screen.dart';
import '../features/profile/presentation/pages/security_settings_screen.dart';
import '../features/transfer/presentation/pages/transfer_screen.dart';
import '../features/topup/presentation/pages/topup_screen.dart';
import '../features/bills/presentation/pages/bills_screen.dart';
import '../features/home/presentation/pages/processing_screen.dart';
import '../models/transaction_model.dart';

class AppRoutes {
  AppRoutes._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      // Splash
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // Auth routes group
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        builder: (context, state) => const OTPScreen(),
      ),
      GoRoute(
        path: '/auth/new-password',
        builder: (context, state) => const NewPasswordScreen(),
      ),
      GoRoute(
        path: '/main/transaction-details',
        builder: (context, state) {
          final transaction = state.extra as TransactionModel;
          return TransactionDetailsScreen(transaction: transaction);
        },
      ),
      // Shared Processing screen
      GoRoute(
        path: '/main/processing',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final payload = extra['payload'] as Map<String, dynamic>;
          final nextRoute = extra['nextRoute'] as String;
          return ProcessingScreen(payload: payload, nextRoute: nextRoute);
        },
      ),
      // Transfer Flow
      GoRoute(
        path: '/main/transfer',
        builder: (context, state) => const TransferScreen(),
      ),
      GoRoute(
        path: '/main/transfer/success',
        builder: (context, state) {
          final payload = state.extra as Map<String, dynamic>?;
          return TransferScreen(initialPayload: payload);
        },
      ),
      // TopUp Flow
      GoRoute(
        path: '/main/topup',
        builder: (context, state) => const TopUpScreen(),
      ),
      GoRoute(
        path: '/main/topup/success',
        builder: (context, state) {
          final payload = state.extra as Map<String, dynamic>?;
          return TopUpScreen(initialPayload: payload);
        },
      ),
      // Bills Flow
      GoRoute(
        path: '/main/bills',
        builder: (context, state) => const BillsScreen(),
      ),
      GoRoute(
        path: '/main/bills/success',
        builder: (context, state) {
          final payload = state.extra as Map<String, dynamic>?;
          return BillsScreen(initialPayload: payload);
        },
      ),

      // Profile Sub-screens
      GoRoute(
        path: '/main/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/main/profile/preferences',
        builder: (context, state) => const AppPreferencesScreen(),
      ),
      GoRoute(
        path: '/main/profile/security',
        builder: (context, state) => const SecuritySettingsScreen(),
      ),
      GoRoute(
        path: '/main/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/main/help-center',
        builder: (context, state) => const HelpCenterScreen(),
      ),

      // Main shell flow
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/main/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/main/transactions',
            builder: (context, state) => const TransactionsScreen(),
          ),
          GoRoute(
            path: '/main/statistics',
            builder: (context, state) => const StatisticsScreen(),
          ),
          GoRoute(
            path: '/main/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
