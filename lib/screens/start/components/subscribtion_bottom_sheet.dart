import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lordan_v1/global.dart';
import 'package:lordan_v1/screens/home_screen.dart';
import 'package:lordan_v1/screens/paywall/paywall_screen.dart';
import 'package:lordan_v1/providers/subscribtion_provider.dart';
import 'package:lordan_v1/screens/paywall/plans_comparison.dart';

class SubscriptionBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0072ff), Color(0xFF00c6ff)], // Blue gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Title
              const Text(
                "Subscription Details",
                style: TextStyle(
                  fontFamily: 'Roboto', // WhatsApp-like clean font
                  color: Color.fromARGB(255, 1, 24, 100),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 14),

              // List items
              _infoRow("Email", GlobalData.user!.email),
              GlobalData.user!.status != "free"
                  ? _infoRow("Status",
                      GlobalData.planInProgresss ?? GlobalData.user!.status)
                  : _infoRow("Status", "Unsubscribed"),

              GlobalData.user!.status != "free"
                  ? _infoRow("Purchased",
                      GlobalData.user!.updatedAt.toLocal().toString())
                  : const Center(
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Subscribe to avail services",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    )),

              GlobalData.user!.status != "free"
                  ? _infoRow("Expires at",
                      GlobalData.user!.expiresAt!.toLocal().toString())
                  : const SizedBox(),

              const SizedBox(height: 20),

              // Upgrade button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0072ff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    elevation: 5,
                  ),
                  onPressed: () {
                    // TODO: Handle upgrade logic
                    context.go(PaywallScreen.routeName);

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Upgrade Package",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GlobalData.user!.status != "free"
                  ? GestureDetector(
                      onTap: () async {
                        await SubscriptionService.openPlayStoreSubscriptionPage(
                            'lordan_subscription'); // 👈 your SKU/product ID
                        // await SubscriptionService.checkSubscriptionStatus();
                      },
                      child: const Text(
                        "Cancel Subscription",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            decorationColor: Colors.red,
                            decorationStyle: TextDecorationStyle.dashed),
                      ),
                    )
                  : Center(
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
            ],
          ),
        );
      },
    );
  }

  static Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Example mock data structure for testing
