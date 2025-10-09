import 'package:flutter/material.dart';
import 'package:lordan_v1/utils/components/glass_card.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../../utils/components/gradient_backdrop.dart';
import '../../../utils/components/primary_back_button.dart';

class FaqScreen extends StatelessWidget {
  static const String routeName = '/faq';

  const FaqScreen({super.key});

  final List<Map<String, String>> _faqData = const [
    {"q": "What is this app about?", "a": "This app helps you practice conversations with different roles and scenarios using AI."},
    {"q": "Do I need Premium?", "a": "Free users can access basic roles, while Premium unlocks all roles and extra features."},
    {"q": "Is my data private?", "a": "Yes, conversations are stored locally and nothing is sent to external servers without your consent."},
    {"q": "Can I cancel anytime?", "a": "Yes, you can cancel your Premium subscription at any time from the Settings screen."},
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    bool isDark = userProvider.themeMode == ThemeMode.dark;
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          GradientBackdrop(isDark: isDark),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const PrimaryBackButton(),
                    const SizedBox(width: 30),
                    Text(
                      'Frequently Asked\n Questions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _faqData.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12.0),
                    itemBuilder: (context, index) {
                      return GlassCard(
                        radiusBottom: const Radius.circular(24),
                        radiusTop: const Radius.circular(24),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            dense: false,
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,
                            tilePadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            childrenPadding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 16,
                            ),
                            title: Text(
                              _faqData[index]["q"]!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            children: [
                              Text(
                                _faqData[index]["a"]!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
