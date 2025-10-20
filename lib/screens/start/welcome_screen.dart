import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:lordan_v1/screens/chat/chat_text_screen.dart';
import 'package:lordan_v1/screens/home_screen.dart';
import 'package:lordan_v1/screens/start/auth/login_screen.dart';
import 'package:lordan_v1/service/user_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../providers/user_provider.dart';
import '../../utils/components/primary_button.dart';
import '../../utils/components/gradient_backdrop.dart';
import 'language_selection_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routeName = "/welcome";

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    bool isDark = userProvider.themeMode == ThemeMode.dark;
    final textColor =
        isDark ? Colors.white.withValues(alpha: 0.9) : Colors.white;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GradientBackdrop(isDark: isDark),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        "assets/brand_logos/logo_png.png",
                        width: 110,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Title
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "WELCOME TO LORDAN",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontSize: 26,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "PRIVATE",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      "SECURE",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      "ALWAYS READY",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12.0),

                    // Short mission
                    Text(
                      "Your Private AI Conversation Partner",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white.withValues(alpha: .8),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // CTA button
                    PrimaryButton(
                      horizontalMargin: 0,
                      label: "Start Chat",
                      enabled: true,
                      onPressed: () async {
                        final sessionBox = await UserStorageService.getUserBox;

                        // final user =
                        //     Supabase.instance.client.auth.currentUser!.email;
                        // print(user);

                        if (sessionBox.isNotEmpty) {
                          context.push(HomeScreen.routeName);
                        } else {
                          context.push(LoginScreen.routeName);
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Chat Log (secondary button)
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Chat Log coming soon...")),
                        );
                      },
                      child: Text(
                        "Chat Log",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                "LORDAN LABS",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
