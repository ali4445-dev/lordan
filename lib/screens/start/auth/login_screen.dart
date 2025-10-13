import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lordan_v1/methods/google_signing.dart';
import 'package:lordan_v1/screens/start/components/header_section.dart';
import 'package:lordan_v1/screens/start/auth/components/my_phone_input.dart';
import 'package:lordan_v1/service/user_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:lordan_v1/providers/auth_provider.dart';
import 'package:lordan_v1/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../providers/user_provider.dart';
import '../../../utils/components/primary_back_button.dart';
import '../../../utils/components/primary_button.dart';
import '../../../utils/constants.dart';
import '../../../utils/components/gradient_backdrop.dart';
import '../../splash/splash_screen.dart';
import 'components/email_input.dart';
import 'components/remember_checkbox.dart';
import 'components/toggle_button.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // Form controllers for email sign-in
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    bool isDark = userProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const PrimaryBackButton(),
      ),
      body: Stack(
        children: [
          /// COMPONENT: Gradient Background
          GradientBackdrop(isDark: isDark),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  /// COMPONENT: Main Content (Scrollable if needed)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// COMPONENT: Header Section
                          const RepaintBoundary(
                            child: HeaderSection(
                              title: "Welcome Back",
                              subtitle:
                                  "Sign in to access your personalized AI experience",
                              logoVisible: true,
                            ),
                          ),
                          const SizedBox(height: 8),

                          /// COMPONENT: Signed-out State
                          _SignedOutContent(
                            emailController: _emailController,
                            phoneController: phoneController,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  _BottomActions()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// COMPONENT: Login Method Enum
enum LoginMethod { email, phone }

/// COMPONENT: Signed-out State Content (Optimized)
class _SignedOutContent extends StatefulWidget {
  const _SignedOutContent(
      {required this.emailController, required this.phoneController});

  final TextEditingController emailController;
  final TextEditingController phoneController;

  @override
  State<_SignedOutContent> createState() => _SignedOutContentState();
}

class _SignedOutContentState extends State<_SignedOutContent> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  String? emailError;
  LoginMethod loginMethod = LoginMethod.email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    bool isDark = userProvider.themeMode == ThemeMode.dark;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// COMPONENT: Email/Phone Toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.glassDark : AppColors.glassLight,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: isDark ? 0.06 : 0.18),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ToggleButton(
                  label: "Email",
                  isActive: loginMethod == LoginMethod.email,
                  onTap: () => setState(() {
                    loginMethod = LoginMethod.email;
                  }),
                ),
                ToggleButton(
                  label: "Phone",
                  // isActive: loginMethod == LoginMethod.phone,
                  isActive: false,

                  onTap: () => setState(() {
                    loginMethod = LoginMethod.phone;
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          /// SWITCH: Email ↔ Phone
          if (loginMethod == LoginMethod.email) ...[
            // Email Input
            EmailInput(
              controller: widget.emailController,
              onErrorChanged: (err) => setState(() => emailError = err),
              errorText: emailError,
              isDark: false,
            ),
            const SizedBox(height: 16),

            // Remember me
            RememberMeCheckbox(
              value: _rememberMe,
              onChanged: (v) => setState(() => _rememberMe = v ?? false),
            ),
            const SizedBox(height: 24),

            // Email Sign-in Button
            Selector<AuthProvider, bool>(
              selector: (_, provider) => provider.isLoading,
              builder: (context, isLoading, child) {
                return _EmailSignInButton(
                  emailController: widget.emailController,
                  formKey: _formKey,
                  isLoading: isLoading,
                );
              },
            ),
          ] else ...[
            // Phone Input
            MyPhoneInput(controller: widget.phoneController),
            const SizedBox(height: 16),

            RememberMeCheckbox(
              value: _rememberMe,
              onChanged: (v) => setState(() => _rememberMe = v ?? false),
            ),
            const SizedBox(height: 24),

            // Phone Sign-in Button
            PrimaryButton(
              horizontalMargin: 0,
              label: "Continue with Phone",
              enabled: true,
              onPressed: () async {
                // TODO: phone login flow
              },
            ),
          ],

          const SizedBox(height: 24),

          /// COMPONENT: Divider
          Row(
            children: [
              Expanded(
                child: Divider(
                    color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.2)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'or',
                  style:
                      theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
              ),
              Expanded(
                child: Divider(
                    color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.2)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          /// COMPONENT: Social Sign-in Buttons
          const _SocialSignInButtons(),
        ],
      ),
    );
  }
}

/// COMPONENT: Email Sign-in Button (Optimized)
class _EmailSignInButton extends StatelessWidget {
  const _EmailSignInButton({
    required this.emailController,
    required this.formKey,
    required this.isLoading,
  });

  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return // CTA button
        PrimaryButton(
      horizontalMargin: 0,
      label: "Continue with Email",
      enabled: true,
      onPressed: isLoading
          ? null
          : () async {
              if (formKey.currentState?.validate() ?? false) {
                await context
                    .read<AuthProvider>()
                    .sendEmailOtp(email: emailController.text);
                context.push(RoutePaths.otp);
              }
              //   await context
              //       .read<AuthProvider>()
              //       .mockSignInEmail(emailController.text.trim());
              // }
            },
    );
  }
}

class _SocialSignInButtons extends StatelessWidget {
  const _SocialSignInButtons();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SocialButton(
          icon: 'assets/icons/google.svg',
          label: 'Continue with Google',
          color: Colors.white.withValues(alpha: 0.7),
          textColor: Colors.black,
          onPressed: () async {
            try {
              AuthResponse response;
              bool successLogin = false;

              if (kIsWeb) {
                successLogin =
                    await Supabase.instance.client.auth.signInWithOAuth(
                  OAuthProvider.google,
                );
                print(Supabase.instance.client.accessToken);
              } else if (Platform.isAndroid || Platform.isIOS) {
                response = await nativeGoogleSignIn();
                print(response);
                successLogin = true;
              } else {
                throw 'Unsupported platform';
              }

              if (successLogin) {
                UserStorageService.saveUserData();
                // ✅ Save session or navigate now
                // context.read<AuthProvider>().saveUserSession();

                context.go(SplashScreen.routeName);
              } else {
                debugPrint('❌ Login failed: No session returned');
              }
            } catch (e) {
              debugPrint('🚨 Google sign-in error: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sign-in failed: $e')),
              );
            }
          },
        ),
        const SizedBox(height: 12),
        _SocialButton(
          icon: 'assets/icons/apple.svg',
          label: 'Continue with Apple',
          color: Colors.black,
          textColor: Colors.white,
          // onPressed: () => authProvider.mockSignInApple(),
          onPressed: () {},
        ),
      ],
    );
  }
}

/// COMPONENT: Social Button
class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    this.textColor,
    required this.onPressed,
    this.borderColor,
  });

  final String icon;
  final String label;
  final Color color;
  final Color? textColor;
  final Color? borderColor;

  // final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        icon,
        width: 24,
      ),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
      ),
    );
  }
}

/// COMPONENT: Bottom Actions (for signed-out state)
class _BottomActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        /// COMPONENT: Terms and Privacy
        FittedBox(
          child: Row(
            children: [
              Text(
                'By signing in, you agree to our ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Terms of Service (placeholder)')),
                  );
                },
                child: Text(
                  'Terms',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                ' and ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Privacy Policy (placeholder)')),
                  );
                },
                child: Text(
                  'Privacy Policy',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}
