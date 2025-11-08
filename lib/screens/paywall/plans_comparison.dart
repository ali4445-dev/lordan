import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lordan_v1/providers/subscribtion_provider.dart';
import 'package:lordan_v1/providers/user_provider.dart';
import 'package:lordan_v1/utils/components/gradient_backdrop.dart';
import 'package:lordan_v1/models/products.dart';
import 'package:lordan_v1/global.dart';

class ComparisonScreen extends StatefulWidget {
  static const String routeName = '/comparison';
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  @override
  void initState() {
    super.initState();
    // SubscriptionService().init();
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/brand_logos/logo_text.png',
                    height: 60,
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Choose your plan and unlock your private AI companion\nfor clear, confident thinking.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// ----------------------------
                  /// 🟦 STANDARD PLAN CARD
                  /// ----------------------------
                  _PlanCard(
                    title: '🟦 Standard',
                    subtitle: 'For focused daily use.',
                    features: const [
                      "Voice or text conversations in 11 languages",
                      "Short, concise replies for clarity and insight",
                      "Structured reasoning and reflection",
                      "Private, encrypted sessions",
                      "Up to 10 daily conversations",
                    ],
                    buttonText: 'Continue with Standard',
                    onPressed: () async {
                      try {
                        GlobalData.planInProgresss = "Standard Plan";
                        // await subService.buy(effectiveProducts[0]);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('⏳ Processing Standard Plan...'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('❌ Error: $e'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  /// ----------------------------
                  /// 🟨 PREMIUM PLAN CARD
                  /// ----------------------------
                  _PlanCard(
                    title: '🟨 Premium',
                    subtitle: 'For professionals, learners, and deep thinkers.',
                    features: const [
                      "Everything in Standard, plus:",
                      "Flow Mode — hands-free up to 12 exchanges",
                      "3× longer sessions and deeper analysis",
                      "HD voice with natural emotional tone",
                      "Language fluency and pronunciation training",
                      "Priority speed and early access to new features",
                      "Advanced reasoning across every domain",
                    ],
                    buttonText: 'Upgrade to Premium',
                    onPressed: () async {
                      try {
                        // GlobalData.planInProgresss = "Premium Plan";
                        // await subService.buy(effectiveProducts[2]);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text('⏳ Processing Premium Plan...'),
                        //   ),
                        // );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('❌ Error: $e'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 30),

                  /// Footer (compliance)
                  Text(
                    'Subscriptions renew automatically unless canceled at least 24 hours before renewal.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ----------------------------
/// PLAN CARD WIDGET
/// ----------------------------
class _PlanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> features;
  final String buttonText;
  final VoidCallback onPressed;

  const _PlanCard({
    required this.title,
    required this.subtitle,
    required this.features,
    required this.buttonText,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3A0CA3), Color(0xFF7209B7), Color(0xFF4361EE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              subtitle,
              style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: features
                .map(
                  (f) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.yellowAccent.withOpacity(0.9),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            f,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 250, 234, 234)
                                  .withOpacity(0.9),
                              fontSize: 16,
                              height: 1.4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 30),
          // Container(
          //   width: double.infinity,
          //   height: 48,
          //   decoration: BoxDecoration(
          //     gradient: const LinearGradient(
          //       colors: [Color(0xFFFFE29F), Color(0xFFFFD700)],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //     borderRadius: BorderRadius.circular(30),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.yellowAccent.withOpacity(0.4),
          //         blurRadius: 10,
          //         offset: const Offset(0, 4),
          //       ),
          //     ],
          //   ),
          //   child: ElevatedButton(
          //     onPressed: onPressed,
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.transparent,
          //       shadowColor: Colors.transparent,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(30),
          //       ),
          //     ),
          //     child: Text(
          //       buttonText,
          //       style: const TextStyle(
          //         color: Colors.black,
          //         fontWeight: FontWeight.bold,
          //         fontSize: 15,
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 10),
          // Text(
          //   "Secure payments • Cancel anytime • Privacy-first",
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: Colors.white.withOpacity(0.6),
          //     fontSize: 11.5,
          //   ),
          // ),
        ],
      ),
    );
  }
}
