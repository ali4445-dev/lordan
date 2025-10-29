import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../../utils/components/glass_card.dart';
import '../../../utils/components/gradient_backdrop.dart';
import '../../../utils/components/primary_back_button.dart';

class TermsOfServiceScreen extends StatelessWidget {
  static const String routeName = '/terms-of-service';

  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    bool isDark = userProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GradientBackdrop(isDark: isDark),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const PrimaryBackButton(),
                    const SizedBox(width: 46),
                    Text(
                      'Terms of Service',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: GlassCard(
                      radiusTop: Radius.circular(20),
                      radiusBottom: Radius.circular(20),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Text(
                                _privacyText,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

const String _privacyText = """
Terms of Use
​Effective Date:​​October 18, 2025​
​By using Lordan, you agree to these Terms of Use.​

​1. Acceptance​
​These Terms form a legal agreement between you and Lordan Labs LLC. If you don't accept​
​them, please don't use the app.​

​2. Not Medical or Therapy​
​Lordan is an educational tool for thinking and communication skills—not therapy, medical​
​advice, diagnosis, or treatment. It does not provide crisis support.​
​If you're experiencing an emergency, contact local emergency services immediately.​
​Lordan is not a substitute for professional medical or psychological care.​

​3. Responsible Use​
​You agree not to misuse, hack, or reverse-engineer the service, share illegal or harmful content
​or violate applicable laws.​​We may suspend or terminate access if you violate these Terms.​

​4. Privacy & Session Memory​
​Lordan uses temporary session memory for conversation continuity. This memory is​
​automatically deleted after 24 hours and is never shared or used for AI training.​
​Premium users can manually delete session memory anytime.​
​See our Privacy Policy for full details.​

​5. Intellectual Property​
​All content, features, and technology are owned by Lordan Labs LLC. You may not copy,​
​redistribute, or reuse without written permission.​

​6. Platform Terms​
​Your use is also subject to App Store or Google Play terms of service.​

​7. Limitation of Liability​
​Lordan is provided "as-is." We are not liable for any damages related to your use of the service,​
​to the maximum extent allowed by law.​

​8. Changes​
​We may update these Terms and the app's design or features at any time. Continued use​
​means you accept the changes.​

​9. Contact​
​Questions? Email us at​​info@lordan.io​
​Lordan Labs LLC​

​New Jersey, USA​
​Last updated: October 18, 2025
""";
