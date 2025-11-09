// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:lordan_v1/screens/home_screen_pages/settings/components/setting_tile.dart';
//
// import '../../../utils/components/gradient_backdrop.dart';
// import 'components/theme_toggle_tile.dart';
//
// class SettingsScreen extends StatelessWidget {
//   static const String routeName = '/settings';
//
//   const SettingsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     bool _isDarkMode = false;
//
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           const GradientBackdrop(isDark: false),
//           SafeArea(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               children: [
//                 const Column(
//                   children: [
//                     Icon(Icons.account_circle, size: 100),
//                     Text('Zohidov Abduazim'),
//                     Text('zohidov.abduazim@gmail.com'),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.25),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
//                   ),
//                   child: Column(
//                     children: [
//                       SettingTile(
//                         leading: FaIcon(FontAwesomeIcons.earthAmericas),
//                         title: 'Languages',
//                         trailing: Icon(Icons.arrow_forward_ios),
//                       ),
//                       ThemeToggleTile(
//                         isDarkMode: _isDarkMode,
//                         onToggle: (value) {
//                           _isDarkMode = !value;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.25),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
//                   ),
//                   child: const Column(
//                     children: [
//                       SettingTile(
//                         leading: FaIcon(FontAwesomeIcons.microphone),
//                         title: 'Voice Selection',
//                         trailing: Icon(Icons.arrow_forward_ios),
//                       ),
//                       SettingTile(
//                         leading: FaIcon(FontAwesomeIcons.solidCirclePlay),
//                         title: 'Auto-play voice replies',
//                         trailing: Icon(Icons.arrow_forward_ios),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.25),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
//                   ),
//                   child: Column(
//                     children: [
//                       const SettingTile(
//                         leading: FaIcon(FontAwesomeIcons.lock),
//                         title: 'Privacy Policy',
//                         trailing: Icon(Icons.arrow_forward_ios),
//                       ),
//                       SettingTile(
//                         leading: FaIcon(FontAwesomeIcons.fileContract),
//                         title: 'Terms of Service',
//                         trailing: Icon(Icons.arrow_forward_ios),
//                       ),
//                       SettingTile(
//                         leading: FaIcon(FontAwesomeIcons.userShield),
//                         title: 'FAQ / Trust & Safety',
//                         trailing: Icon(Icons.arrow_forward_ios),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.25),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
//                   ),
//                   child: const SettingTile(
//                     leading: FaIcon(FontAwesomeIcons.rightFromBracket),
//                     title: 'Logout',
//                     trailing: Icon(Icons.arrow_forward_ios),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lordan_v1/global.dart';
import 'package:lordan_v1/providers/auth_provider.dart';
import 'package:lordan_v1/screens/home_screen_pages/settings/about_screen.dart';
import 'package:lordan_v1/screens/home_screen_pages/settings/company_screen.dart';
import 'package:lordan_v1/screens/home_screen_pages/settings/components/setting_tile.dart';
import 'package:lordan_v1/screens/home_screen_pages/settings/privacy_policy_screen.dart';
import 'package:lordan_v1/screens/home_screen_pages/settings/terms_of_service_screen.dart';
import 'package:lordan_v1/screens/paywall/paywall_screen.dart';
import 'package:lordan_v1/screens/start/components/app_bar.dart';
import 'package:lordan_v1/screens/start/language_selection_screen.dart';
import 'package:lordan_v1/screens/start/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../providers/user_provider.dart';
import '../../../utils/components/gradient_backdrop.dart';
import 'components/theme_toggle_tile.dart';
import 'faq_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final bool _isDarkMode = false;
  bool _autoPlayReplies = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    bool isDark = userProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GradientBackdrop(isDark: isDark),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 10),
                buildTopBar(theme, context,
                    isPremiumUser: userProvider.isPremium,
                    isDefaultPadding: true),
                const SizedBox(height: 10),
                Column(
                  children: [
                    CircleAvatar(
                      radius:
                          40, // same size as old icon (Icon size 100 → radius 50)
                      backgroundColor: Colors.white.withOpacity(0.15),
                      child: Text(
                        GlobalData.user!.email.isNotEmpty
                            ? GlobalData.user!.email[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      GlobalData.user!.email,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 14.0),
                // Language + Theme
                _buildSection(
                  children: [
                    SettingTile(
                      leading: const FaIcon(FontAwesomeIcons.earthAmericas,
                          color: Colors.white),
                      title: 'Languages',
                      titleStyle: theme.textTheme.labelLarge
                          ?.copyWith(color: Colors.white),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white),
                      onTap: () {
                        context.push(LanguageSelectionScreen.routeName);
                      },
                    ),
                    // Divider(
                    //   color: Colors.white.withValues(alpha: 0.25),
                    //   thickness: 1,
                    //   indent: 54.0,
                    // ),
                    // ThemeToggleTile(
                    //   iconColor: Colors.white,
                    //   isDarkMode: userProvider.themeMode == ThemeMode.dark,
                    //   titleStyle: theme.textTheme.labelLarge
                    //       ?.copyWith(color: Colors.white),
                    //   onToggle: (value) {
                    //     // userProvider.toggleTheme(value);
                    //   },
                    // ),
                  ],
                ),
                const SizedBox(height: 14.0),
                // Auto-play
                _buildSection(
                  children: [
                    SettingTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.solidCirclePlay,
                        color: Colors.white,
                      ),
                      title: 'Voice & Transcript',
                      sub_title: 'Read responses as you listen',
                      titleStyle: theme.textTheme.labelLarge
                          ?.copyWith(color: Colors.white),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (GlobalData.user!.status != "premium") ...[
                            const Icon(
                              FontAwesomeIcons.crown,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 8),
                          ],
                          AbsorbPointer(
                            absorbing: GlobalData.user!.status !=
                                "premium", // disables switch if not premium
                            child: CupertinoSwitch(
                              value: GlobalData.autoPlay,
                              onChanged: (value) {
                                setState(() => _autoPlayReplies = value);
                                GlobalData.setAutoReply(value);
                              },
                              activeTrackColor: Colors.blueAccent,
                              inactiveTrackColor:
                                  Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        if (GlobalData.plan != "premium") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Upgrade to premium to unlock this feature!'),
                            ),
                          );
                          context.push(PaywallScreen.routeName);
                        }
                      },
                    )
                  ],
                ),

                const SizedBox(height: 14.0),

                _buildSection(
                  children: [
                    SettingTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.solidCirclePlay,
                        color: Colors.white,
                      ),
                      title: 'HD Voice',
                      sub_title: 'May reduce response speed',
                      titleStyle: theme.textTheme.labelLarge
                          ?.copyWith(color: Colors.white),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (GlobalData.user!.status != "premium") ...[
                            const Icon(
                              FontAwesomeIcons.crown,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 8),
                          ],
                          AbsorbPointer(
                            absorbing: GlobalData.user!.status !=
                                "premium", // disables switch if not premium
                            child: CupertinoSwitch(
                              value: GlobalData.hd_quality,
                              onChanged: (value) {
                                setState(() => _autoPlayReplies = value);
                                GlobalData.setHdQuality(value);
                              },
                              activeTrackColor: Colors.blueAccent,
                              inactiveTrackColor:
                                  Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        if (GlobalData.plan != "premium") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Upgrade to premium to unlock this feature!'),
                            ),
                          );
                          context.push(PaywallScreen.routeName);
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(height: 14.0),
                // Privacy, Terms, FAQ
                _buildSection(
                  children: [
                    SettingTile(
                      onTap: () => context.push(CompanyScreen.routeName),
                      leading: const FaIcon(FontAwesomeIcons.fileContract,
                          color: Colors.white),
                      title: 'Terms of Use',
                      titleStyle: const TextStyle(color: Colors.white),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white),
                    ),
                    // Divider(
                    //   color: Colors.white.withValues(alpha: 0.25),
                    //   thickness: 1,
                    //   indent: 54.0,
                    // ),
                  ],
                ),
                const SizedBox(height: 14.0),
                // Logout
                _buildSection(
                  children: [
                    SettingTile(
                      leading: const FaIcon(FontAwesomeIcons.rightFromBracket,
                          color: Colors.redAccent),
                      title: 'Logout',
                      titleStyle: const TextStyle(color: Colors.white),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white),
                      onTap: () async {
                        await context.read<AuthProvider>().signOut();
                        context.go(WelcomeScreen.routeName);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14.0),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7, // max width
                    padding: const EdgeInsets.all(8),

                    child: RichText(
                      textAlign: TextAlign.center, // Centers the whole block
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "Have questions? Find FAQs and guidance on our homepage ",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: Colors.white, height: 1.3),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: GestureDetector(
                              onTap: () async {
                                final Uri url = Uri.parse('https://lordan.io');
                                if (!await launchUrl(url,
                                    mode: LaunchMode.externalApplication)) {
                                  throw Exception('Could not launch $url');
                                }
                              },
                              child: Text(
                                'here',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255, 170, 132, 5)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Column(children: children),
    );
  }
}
