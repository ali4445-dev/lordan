import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lordan_v1/models/products.dart';
import 'package:lordan_v1/providers/subscribtion_provider.dart';
import 'package:lordan_v1/screens/paywall/components/features.dart';
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
  String getPlanTitle(String id) {
    if (id.contains('premium') && id.contains('monthly'))
      return 'Premium Monthly';
    if (id.contains('premium') && id.contains('yearly'))
      return 'Premium Yearly';
    if (id.contains('standard') && id.contains('monthly'))
      return 'Standard Monthly';
    if (id.contains('standard') && id.contains('yearly'))
      return 'Standard Yearly';
    return id; // fallback
  }

  String getPlanDescription(String id) {
    if (id.contains('premium') && id.contains('monthly'))
      return 'Full premium access for 1 month';
    if (id.contains('premium') && id.contains('yearly'))
      return 'Full premium access for 1 Year';
    if (id.contains('standard') && id.contains('monthly'))
      return 'Access all features for 1 month';
    if (id.contains('standard') && id.contains('yearly'))
      return 'Access all features for 1 Year';
    return '';
  }

  List<String> getPlanFeatures(String id) {
    if (id.contains('premium')) {
      return [
        "Up to 100 summaries",
        "Delete summary on tap",
        "Continue contextual chat from selected summary",
        "Free speak questions (up to 6)",
        "Switch auto speak",
        "All modes"
      ];
    }
    if (id.contains('standard')) {
      return ["Up to 10 summaries", "Limited modes", "Chat on tap"];
    }
    return [];
  }

  final List<Product> mockProducts = [
    Product(
      id: 'standard-monthly',
      title: 'Standard Monthly',
      description: 'Access all features for 1 month',
      price: '\$4.99',
    ),
    Product(
      id: 'premium-monthly',
      title: 'Premium Monthly',
      description: 'Full premium access for 1 month',
      price: '\$9.99',
    ),
    Product(
      id: 'standard-yearly',
      title: 'Standard Yearly',
      description: 'Access all features for 12 months',
      price: '\$49.99',
    ),
    Product(
      id: 'premium-yearly',
      title: 'Premium Yearly',
      description: 'Full premium access for 12 months',
      price: '\$99.99',
    ),
  ];

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
                            child: _PlanWrapper(
                              isSelected: _isYearlySelected,
                              child: _PlanButton(
                                title: 'Yearly',
                                isSelected: _isYearlySelected,
                                onTap: () =>
                                    setState(() => _isYearlySelected = true),
                              ),
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
                        children: products
                            .where((p) => _isYearlySelected
                                ? p.id.contains('yearly')
                                : p.id.contains('monthly'))
                            .map((product) => Card(
                                  color: Colors.white.withAlpha(20),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: ListTile(
                                    title: Text(
                                      getPlanTitle(product.id),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        buildFeatureList(
                                            getPlanFeatures(product.id))
                                      ],
                                    ),
                                    trailing: Text(
                                      product.price,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onTap: () async {
                                      try {
                                        await subService.buy(product);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              '⏳ Processing purchase for ${product.title}...'),
                                        ));
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('❌ Error: $e'),
                                          backgroundColor: Colors.redAccent,
                                        ));
                                      }
                                    },
                                  ),
                                ))
                            .toList(),
                      ),

                    const SizedBox(height: 24),

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
