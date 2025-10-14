import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lordan_v1/screens/home_screen.dart';
import 'package:lordan_v1/screens/paywall/stripe_payment_screen.dart';
import 'package:lordan_v1/utils/components/primary_back_button.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../utils/components/gradient_backdrop.dart';

class PaywallScreen extends StatefulWidget {
  static const String routeName = '/paywall';

  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isYearlySelected = false;

  final List<Map<String, String>> _features = const [
    {
      "title": "All Premium Roles",
      "description": "Access 20+ conversation roles"
    },
    {
      "title": "Voice Conversations",
      "description": "Natural voice interactions"
    },
    {
      "title": "Conversation History",
      "description": "Resume past sessions anytime"
    },
    {"title": "Advanced AI", "description": "Enhanced context understanding"},
    {"title": "Priority Support", "description": "Get help when you need it"},
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    bool isDark = userProvider.themeMode == ThemeMode.dark;
    return Scaffold(
      body: Stack(
        children: [
          GradientBackdrop(isDark: isDark),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    // Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Image.asset(
                          'assets/brand_logos/logo_text.png',
                          height: 60,
                        ),
                        GestureDetector(
                          onTap: () => context.push(HomeScreen.routeName),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 120),
                    // Title
                    const Text(
                      'Upgrade to Premium',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Plan Switcher
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _PlanWrapper(
                              isSelected: !_isYearlySelected,
                              child: _PlanButton(
                                title: 'Monthly',
                                isSelected: !_isYearlySelected,
                                onTap: () =>
                                    setState(() => _isYearlySelected = false),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              fit: StackFit.passthrough,
                              clipBehavior: Clip.none,
                              children: [
                                _PlanWrapper(
                                  isSelected: _isYearlySelected,
                                  child: _PlanButton(
                                    title: 'Yearly',
                                    isSelected: _isYearlySelected,
                                    onTap: () => setState(
                                        () => _isYearlySelected = true),
                                  ),
                                ),
                                Positioned(
                                  top: -8,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFD700),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Save 16%',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Features List
                    ...List.generate(_features.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withAlpha(20),
                                border: Border.all(
                                  color: const Color(0xFFFFD700),
                                  width: 1.5,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: Color(0xFFFFD700),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _features[index]['title']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _features[index]['description']!,
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(179),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    // CTA Button
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFD700),
                            Colors.amber,
                            Colors.white,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          initPaymentSheet(context, 40);
                        },
                        // Navigator.of(context).pushNamed('/verify'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: const Text(
                          'Upgrade to Premium',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Trust text
                    Text(
                      'Secure payments • Cancel anytime • Privacy-first',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            Colors.white.withValues(alpha: 0.6), // opacity: 0.6
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withAlpha(isSelected ? 255 : 179),
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _PlanWrapper extends StatelessWidget {
  final bool isSelected;
  final Widget child;

  const _PlanWrapper({
    required this.isSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              const Color(0xFFFFFFFF).withValues(alpha: isSelected ? 0.8 : 0.4),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: child,
    );
  }
}
