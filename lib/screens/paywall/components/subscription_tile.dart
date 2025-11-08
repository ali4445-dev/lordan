import 'package:flutter/material.dart';
import 'package:lordan_v1/models/products.dart';

class SubscriptionListWidget extends StatelessWidget {
  final List<Product> products;
  final String planType; // "Monthly" or "Yearly"
  final Function(Product) onTap;

  const SubscriptionListWidget({
    super.key,
    required this.products,
    required this.planType,
    required this.onTap,
  });

  bool _isPremium(String id) => id.contains('premium');
  bool _isYearly(String id) => id.contains('yearly');

  @override
  Widget build(BuildContext context) {
    final filtered = products.where((p) {
      return planType.toLowerCase() == "yearly"
          ? _isYearly(p.id)
          : !_isYearly(p.id);
    }).toList();

    final isDark = Theme.of(context).brightness ==
        Brightness.dark; // For theme consistency

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: filtered.map((product) {
        final isPremium = _isPremium(product.id);
        final bgColor = Colors.white.withAlpha(20);
        final accentColor = isPremium
            ? const Color(0xFFFFD54F) // Soft Yellow for Premium
            : const Color(0xFF81C784); // Soft Green for Standard

        final features = _getFeatures(product.id);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isPremium
                  ? Colors.yellowAccent.withOpacity(0.5)
                  : Colors.greenAccent.withOpacity(0.4),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isPremium
                    ? Colors.yellow.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => onTap(product),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Text(
                      product.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Features list
                  ...features.map((f) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              isPremium
                                  ? Icons.star_rounded
                                  : Icons.check_circle,
                              color: accentColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                f,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 14),

                  // Price badge
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        product.price,
                        style: TextStyle(
                          color: isDark ? Colors.black87 : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<String> _getFeatures(String id) {
    if (id.contains('standard')) {
      return [
        // "Access up to 100 summaries",
        // "Delete summaries instantly",
        "Contextual chat continuation",
        "Switch between all chat modes",
      ];
    } else if (id.contains('premium')) {
      return [
        // "Unlimited summaries",
        "Advanced chat intelligence",
        "Voice-enabled chat with full control",
        "Exclusive access to new AI models",
      ];
    }
    return ["Flexible plan with great value"];
  }
}
