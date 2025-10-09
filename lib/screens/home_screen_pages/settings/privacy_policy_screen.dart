import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../../utils/components/glass_card.dart';
import '../../../utils/components/gradient_backdrop.dart';
import '../../../utils/components/primary_back_button.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const String routeName = '/privacy-policy';

  const PrivacyPolicyScreen({super.key});

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
                      'Privacy Policy',
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
Privacy Policy

Effective Date: September 22, 2025

Company: Lordan Labs LLC

Location: New Jersey, USA

Website: https://lordan.io

1. Your Privacy Matters
At Lordan Labs LLC (“we,” “our,” or “us”), we prioritize privacy. Lordan is designed to minimize data collection and give you full control over your experience.

We do not track, sell, or share your personal data. We collect only what’s needed to deliver a smooth, secure service.

2. What We Collect
On Our Website (Lordan.io):
We may collect limited non-personal data such as:

Device/browser type

General site usage (page views, time on site)

We do not collect personally identifiable information (PII) unless you directly email us or sign up for updates.

In the Lordan App:
If you use the app, we may process:

Microphone input (for voice features) — used in real time, not stored

Email or phone number (for login code access)

Session memory (premium only) — temporary and cleared after each session

We do not store conversations, and no audio or personal data is retained on our servers unless explicitly required to process your request.

3. No Ads. No Tracking. No Sharing.
We do not:

Sell or rent your data

Use tracking ads or analytics from third-party networks

Share your information with anyone outside Lordan Labs

4. Cookies (Minimal Use)
Our site may use basic cookies only for functionality. You can disable cookies in your browser without losing access to the site.

5. Emails (Optional)
If you subscribe or contact us:

We may use your email to respond or share occasional updates

You can opt out at any time

We do not share or sell your email address

6. Children’s Privacy
Lordan is not intended for children under 13. We do not knowingly collect personal data from minors.

7. Your Rights
Depending on your location, you may have the right to:

Access or delete your data

Withdraw consent or unsubscribe

Request information about our data use

To make a request, contact: privacy@lordan.io

8. Updates
We may update this Privacy Policy as needed. Material changes will be posted here.

Last updated: September 22, 2025

9. Contact
Lordan Labs LLC

New Jersey, USA

📧 info@lordan.io
""";
