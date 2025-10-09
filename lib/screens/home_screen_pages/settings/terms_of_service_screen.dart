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

Effective Date: September 22, 2025

Company: Lordan Labs LLC

Website: https://lordan.io

App Platforms: App Store, Google Play, and other authorized platforms

1. Acceptance of Terms
By using the Lordan app or visiting lordan.io, you agree to these Terms of Use (“Terms”). If you do not accept them, please do not use the Service.

These Terms form a legal agreement between you (“you” or “user”) and Lordan Labs LLC, based in New Jersey, USA (“we,” “our,” or “us”).

2. No Therapy or Medical Advice
Lordan is not therapy, diagnosis, or a medical service.

It is an AI-powered tool for self-reflection, communication practice, and mental clarity—not a substitute for professional help.

We do not provide:

Medical or psychological advice

Diagnosis or treatment

Emergency or crisis response

If you are in distress, please contact a licensed professional or emergency services.

3. Platform Use
The Lordan app may be downloaded from:

Apple App Store

Google Play Store

Other approved platforms

Your use is subject to these Terms and platform-specific terms (e.g., Apple Media Services, Google Play TOS).

4. Responsible Use
You agree not to:

Misuse, hack, or reverse-engineer the Service

Share abusive, illegal, or harmful content

Violate local or platform-specific laws

We reserve the right to suspend or terminate your access if misuse occurs.

5. Intellectual Property
All content, features, and technology in the app and website are owned by Lordan Labs LLC. You may not copy, reuse, or redistribute without written permission.

6. Temporary Session Memory (Premium App Only)
In the premium version, temporary memory may be used to maintain conversation flow. This:

Exists only during a session

Is cleared immediately after

Is not stored, linked, or shared

This does not apply to the website or free-tier use.

7. Termination
You may stop using the Service at any time. We may suspend or remove access if you violate these Terms or applicable laws.

8. Limitation of Liability
We provide the Service “as-is.” To the maximum extent allowed by law, we are not liable for any direct, indirect, or incidental damages related to your use of the Service.

9. Updates
We may revise these Terms as needed. If updates are significant, we’ll notify you via the app or website. Continued use means you accept the new Terms.

Last updated: September 22, 2025

10. Contact
Questions? Contact us at:

📧 info@lordan.io

Lordan Labs LLC

New Jersey, USA
""";
