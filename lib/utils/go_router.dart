import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lordan_v1/screens/home_screen_pages/settings/about_screen.dart';
import 'package:lordan_v1/screens/home_screen_pages/settings/company_screen.dart';
import 'package:lordan_v1/screens/home_screen_pages/settings/terms_of_service_screen.dart';
import 'package:lordan_v1/screens/start/auth/otp_screen.dart';
import 'package:lordan_v1/screens/start/language_selection_screen.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import '../screens/home_screen_pages/history/history_screen.dart';
import '../screens/home_screen_pages/settings/faq_screen.dart';
import '../screens/home_screen_pages/settings/privacy_policy_screen.dart';
import '../screens/home_screen_pages/settings/settings_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/start/welcome_screen.dart';
import 'constants.dart';

import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';

import '../screens/start/onboarding_screen.dart';
import '../screens/start/auth/login_screen.dart';

import '../screens/chat/chat_text_screen.dart';
import '../screens/chat/chat_voice_screen.dart';

import '../screens/paywall/paywall_screen.dart';

// Export a single GoRouter instance configured with guards and routes
final GoRouter router = GoRouter(
  initialLocation: RoutePaths.welcome,
  redirect: (BuildContext context, GoRouterState state) {
    final auth = context.read<AuthProvider?>();
    final user = context.read<UserProvider?>();

    final bool isAuthed = auth?.isSignedIn ?? false;
    final String goingTo = state.matchedLocation;

    // Public routes that do not require auth
    const publicRoutes = <String>{
      RoutePaths.welcome,
      RoutePaths.languageSelection,
      RoutePaths.onboarding,
      RoutePaths.login,
      RoutePaths.otp,
      // After this routes user is signed in
      RoutePaths.splash,
      RoutePaths.paywall,
      RoutePaths.home,
      RoutePaths.chatText,
      RoutePaths.chatVoice,
      RoutePaths.history,
      RoutePaths.settings,
      RoutePaths.faq,
      RoutePaths.privacyPolicy,
      RoutePaths.termsOfService,
      RoutePaths.about,
      RoutePaths.company,
    };

    // Auth guard
    if (!isAuthed && !publicRoutes.contains(goingTo)) {
      // If navigating to a protected route, send to login; otherwise welcome
      final protectedTargets = <String>{
        // Here we can add protected routes that require auth
      };
      return protectedTargets.contains(goingTo) ? RoutePaths.login : RoutePaths.welcome;
    }

    // Premium guard for voice chat and future premium-only routes
    // final bool isPremium = user?.isPremium ?? false;
    // final premiumOnlyRoutes = <String>{
    //   RoutePaths.chatVoice,
    // };
    // if (premiumOnlyRoutes.contains(goingTo) && !isPremium) {
    //   return RoutePaths.paywall;
    // }

    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: RoutePaths.welcome,
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: RoutePaths.languageSelection,
      name: 'language-selection',
      builder: (context, state) => const LanguageSelectionScreen(),
    ),
    GoRoute(
      path: RoutePaths.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RoutePaths.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RoutePaths.otp,
      name: 'otp',
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: RoutePaths.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RoutePaths.chatText,
      name: 'chat-text',
      builder: (context, state) => ChatTextScreen(
        roleId: (state.extra as Map?)?['roleId'] as String?,
        roleName: (state.extra as Map?)?['roleName'] as String?,
        roleDescription: (state.extra as Map?)?['roleDescription'] as String?,
        isPremium: (state.extra as Map?)?['isPremium'] as bool? ?? false,
      ),
    ),
    GoRoute(
      path: RoutePaths.chatVoice,
      name: 'chat-voice',
      builder: (context, state) => ChatVoiceScreen(
        roleId: (state.extra as Map?)?['roleId'] as String?,
        roleName: (state.extra as Map?)?['roleName'] as String?,
        roleDescription: (state.extra as Map?)?['roleDescription'] as String?,
        isPremium: (state.extra as Map?)?['isPremium'] as bool? ?? false,
      ),
    ),
    GoRoute(
      path: RoutePaths.history,
      name: 'history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: RoutePaths.paywall,
      name: 'paywall',
      builder: (context, state) => const PaywallScreen(),
    ),
    GoRoute(
      path: RoutePaths.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: RoutePaths.faq,
      name: 'faq',
      builder: (context, state) => const FaqScreen(),
    ),
    GoRoute(
      path: RoutePaths.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RoutePaths.privacyPolicy,
      name: 'privacy-policy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: RoutePaths.termsOfService,
      name: 'terms-of-service',
      builder: (context, state) => const TermsOfServiceScreen(),
    ),
    GoRoute(
      path: RoutePaths.about,
      name: 'about',
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: RoutePaths.company,
      name: 'company',
      builder: (context, state) => const CompanyScreen(),
    ),
  ],
);
