import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lordan_v1/global.dart';
import 'package:lordan_v1/models/products.dart';
import 'package:lordan_v1/providers/subscribtion_provider.dart';
import 'package:lordan_v1/screens/paywall/components/features.dart';
import 'package:lordan_v1/screens/paywall/components/plan_card.dart';
import 'package:lordan_v1/screens/paywall/plans_comparison.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

import '../home_screen.dart';
import '../../utils/components/gradient_backdrop.dart';

class PaywallScreen extends StatefulWidget {
  static const String routeName = '/paywall';
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isYearlySelected = false;
  String getPlanTitle(int id) {
    if (id == 0) return 'Standard Monthly';
    if (id == 1) return 'Premium Monthly';
    if (id == 2) return 'Standard Yearly';
    if (id == 3) return 'Premium Yearly';

    return id.toString(); // fallback
  }

  String getPlanDescription(int id) {
    if (id == 1 || id == 3) {
      return 'Think deeply. Speak clearly. Communicate with confidence.h';
    }
    if (id == 0 || id == 2) return 'For focused daily use';

    return '';
  }

  List<String> getPlanFeatures(int index) {
    if (index == 1 || index == 3) {
      return [
        "Flow Mode — hands-free conversation up to 12 exchanges",
        "3× longer sessions for deeper thinking and reflection",
        "HD voice with natural tone and adaptive pacing",
        "Advanced reasoning across all topics and languages",
        "Language fluency and pronunciation practice",
        "Priority speed and early access to new features",
        "Private and encrypted -  nothing stored on servers",
      ];
    }
    if (index == 0 || index == 2) {
      return [
        "Voice or text conversations in 11 languages",
        "Short, concise replies for clarity and insight",
        "Structured reasoning and reflection",
        "Private, encrypted sessions",
        "Up to 10 daily conversations"
      ];
    }
    return [];
  }

  // final List<Product> mockProducts = [
  //   Product(
  //     id: 'standard-monthly',
  //     title: 'Standard Monthly',
  //     description: 'Access all features for 1 month',
  //     price: '\$4.99',
  //   ),
  //   Product(
  //     id: 'premium-monthly',
  //     title: 'Premium Monthly',
  //     description: 'Full premium access for 1 month',
  //     price: '\$9.99',
  //   ),
  //   Product(
  //     id: 'standard-yearly',
  //     title: 'Standard Yearly',
  //     description: 'Access all features for 12 months',
  //     price: '\$49.99',
  //   ),
  //   Product(
  //     id: 'premium-yearly',
  //     title: 'Premium Yearly',
  //     description: 'Full premium access for 12 months',
  //     price: '\$99.99',
  //   ),
  // ];

  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  // }
  void initState() {
    // TODO: implement initState
    // super.initState();
    // SubscriptionService().init();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final subService = Provider.of<SubscriptionService>(context);
    bool isDark = userProvider.themeMode == ThemeMode.dark;

    // Check if products fetched
    final products = subService.products;
    final hasProducts = products.isNotEmpty;

    // final products = mockProducts;
    // final hasProducts = mockProducts.isNotEmpty;

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
                    // Logo + Close
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
                          child: const Icon(Icons.close, color: Colors.white),
                        )
                      ],
                    ),
                    products.isEmpty
                        ? const SizedBox(height: 120)
                        : const SizedBox(height: 30),

                    const Text(
                      'Upgrade to Premium',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    products.isEmpty
                        ? const SizedBox(height: 60)
                        : const SizedBox(height: 30),

                    // Plan switcher
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
                    products.isEmpty
                        ? const SizedBox(height: 50)
                        : const SizedBox(height: 10),

                    // Dynamic products

                    if (!hasProducts)
                      // No products
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    '⚠️ No subscriptions found. Check your Play Console setup.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white24,
                          ),
                          child: const Text(
                            'No Products Available',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    // CTA Button
                    if (hasProducts)
                      Column(
                        children: products.asMap().entries.where((entry) {
                          final index = entry.key;
                          print("Index is $index");
                          print(entry.value.price);
                          if (_isYearlySelected) {
                            return index == 2 || index == 3; // 2nd and 4th
                          } else {
                            return index == 0 || index == 1; // 1st and 3rd
                          }
                        }).map((entry) {
                          final product = entry.value;
                          final index = entry.key;
                          print("Index is $index");
                          print("Price is ${product.price}");
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: PlanCard(
                              buttonText: product.price,
                              features: getPlanFeatures(index),
                              title: getPlanTitle(index),
                              onPressed: () async {
                                try {
                                  GlobalData.planInProgresss =
                                      getPlanTitle(index);

                                  await subService.buy(product);
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //     content: Text(
                                  //       '⏳ Processing purchase for ${product.title}...',
                                  //     ),
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
                              subtitle: getPlanDescription(index),

                              // elevation: 1,
                              // // color: const Color.fromARGB(255, 20, 38, 95),
                              // color: (index == 1 || index == 3)
                              //     ? const Color.fromARGB(255, 20, 35, 39)
                              //     : const Color.fromARGB(255, 13, 40, 70),
                              // margin: const EdgeInsets.symmetric(vertical: 10),
                              // child: ListTile(
                              //   title: Center(
                              //     child: Text(
                              //       // product.id,
                              //       "${getPlanTitle(index)}\n${getPlanDescription(index)}",
                              //       style: TextStyle(
                              //         color: (index == 1 || index == 3)
                              //             ? Colors.green
                              //             : Colors.orangeAccent,
                              //         fontWeight: FontWeight.bold,
                              //         fontSize: 22,
                              //       ),
                              //     ),
                              //   ),
                              //   subtitle: Center(
                              //     child: Column(
                              //       children: [
                              //         buildFeatureList(getPlanFeatures(index)),
                              //         Container(
                              //           padding: const EdgeInsets.only(
                              //               left: 4, right: 4),
                              //           decoration: BoxDecoration(
                              //               color: (index == 1 || index == 3)
                              //                   ? Colors.green
                              //                   : Colors.orangeAccent,
                              //               borderRadius: const BorderRadius.all(
                              //                   Radius.circular(5))),
                              //           child: Text(product.price,
                              //               style: const TextStyle(
                              //                 color: Colors.white,
                              //                 fontWeight: FontWeight.w600,
                              //               )),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              //   // trailing: Text(
                              //   //   product.price,
                              //   //   style: const TextStyle(
                              //   //     color: Colors.white,
                              //   //     fontWeight: FontWeight.w600,
                              //   //   ),
                              //   // ),
                              //   onTap: () async {
                              //     try {
                              //       GlobalData.planInProgresss =
                              //           getPlanTitle(index);
                              //       await subService.buy(product);

                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //           content: Text(
                              //             '⏳ Processing purchase for ${product.title}...',
                              //           ),
                              //         ),
                              //       );
                              //     } catch (e) {
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //           content: Text('❌ Error: $e'),
                              //           backgroundColor: Colors.redAccent,
                              //         ),
                              //       );
                              //     }
                              //   },
                              // ),
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 5),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ComparisonScreen(),
                              )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: const Text(
                            'Why to upgrade?',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(221, 28, 31, 24),
                                decorationStyle: TextDecorationStyle.double),
                          ),
                        ),
                      ),
                    ),

                    // ListTile(
                    //   title: Text(products.first.title),
                    //   subtitle: Text(products.first.description),
                    // ),

                    Text(
                      'Secure payments • Cancel anytime • Privacy-first',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
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
  const _PlanButton(
      {required this.title, required this.isSelected, required this.onTap});

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
  const _PlanWrapper({required this.isSelected, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(isSelected ? 0.8 : 0.4),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: child,
    );
  }
}
