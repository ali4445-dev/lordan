import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lordan_v1/screens/home_screen_pages/settings/privacy_policy_screen.dart';
import 'package:lordan_v1/screens/home_screen_pages/settings/terms_of_service_screen.dart';
import 'package:lordan_v1/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../providers/user_provider.dart';
import '../../../utils/components/glass_card.dart';
import '../../../utils/components/gradient_backdrop.dart';
import '../../../utils/components/primary_back_button.dart';

class CompanyScreen extends StatefulWidget {
  static const String routeName = '/company';

  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  late List<ExpansionTileController> _controllers;

  final List<Map<String, String>> _faqData = const [
    {"q": "About Us", "a": ""},
    {"q": "Privacy Policy", "a": privacyText},
    {"q": "Terms of Use", "a": termsOfServiceText},
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_faqData.length, (_) => ExpansionTileController());
  }

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const PrimaryBackButton(),
                    const SizedBox(width: 60),
                    Text(
                      'Terms of Use',
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
                            controller: _controllers[index],
                            onExpansionChanged: (bool expanded) {
                              if (expanded) {
                                for (int i = 0; i < _controllers.length; i++) {
                                  if (i != index) {
                                    _controllers[i].collapse();
                                  }
                                }
                              }
                            },
                            dense: false,
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,
                            tilePadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
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
                              if (index == 0) ...[
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.58,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
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
                                        const SizedBox(height: 8),
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
                                        const SizedBox(height: 8),
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
                                        const SizedBox(height: 14),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              onPressed: () => context.push(PrivacyPolicyScreen.routeName),
                                              child: const Text(
                                                "Privacy Policy",
                                                style: TextStyle(color: Colors.white, fontSize: 12),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () => context.push(TermsOfServiceScreen.routeName),
                                              child: const Text(
                                                "Terms of Use",
                                                style: TextStyle(color: Colors.white, fontSize: 12),
                                              ),
                                            ),
                                            Flexible(
                                              child: TextButton(
                                                onPressed: () => _launchUrl("mailto:info@lordan.io"),
                                                child: const Text(
                                                  "Contact",
                                                  style: TextStyle(color: Colors.white, fontSize: 12),
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
                              ] else ...[
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.58,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      _faqData[index]["a"]!,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ]
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
