import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lordan_v1/screens/home_screen_pages/settings/privacy_policy_screen.dart';
import 'package:lordan_v1/screens/home_screen_pages/settings/terms_of_service_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/components/glass_card.dart';
import '../../../utils/components/gradient_backdrop.dart';
import '../../../utils/components/primary_back_button.dart';

class AboutScreen extends StatelessWidget {
  static const String routeName = '/about';

  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    bool isDark = userProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: Stack(
        children: [
          GradientBackdrop(isDark: isDark),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const PrimaryBackButton(),
                    // const SizedBox(width: 100),
                    Text(
                      'About',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 50),
                  ],
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: GlassCard(
                      radiusTop: const Radius.circular(20),
                      radiusBottom: const Radius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "About Lordan",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Lordan is your private AI conversation partner—built to help you think clearly, "
                              "speak effectively, and organize ideas. It’s a space to become a better thinker, "
                              "speaker, and communicator.",
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "• No tracking. No selling data.\n"
                              "• Built for professionals, students, leaders, and anyone who wants to communicate better.\n"
                              "• Available in 11 languages, with free and premium options.",
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.5,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Created by Lordan Labs LLC (New Jersey, USA), an education and AI technology company "
                              "founded in 2025. Our mission is to give people a private, trustworthy space to practice "
                              "meaningful conversations and sharpen their thinking.",
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.5,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: TextButton(
                                    onPressed: () => context
                                        .push(PrivacyPolicyScreen.routeName),
                                    child: const Text(
                                      "Privacy Policy",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: TextButton(
                                    onPressed: () => context
                                        .push(TermsOfServiceScreen.routeName),
                                    child: const Text(
                                      "Terms of Use",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () =>
                                        _launchUrl("https://info@lordan.io"),
                                    child: const Text(
                                      "Contact",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
