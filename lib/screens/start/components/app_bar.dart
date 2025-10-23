import 'package:flutter/material.dart';

Widget buildTopBar(ThemeData theme,
    {required bool isPremiumUser, bool isDefaultPadding = false}) {
  return Container(
    margin: isDefaultPadding ? null : const EdgeInsets.fromLTRB(16, 0, 16, 16),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.15),
          Colors.white.withValues(alpha: 0.05),
        ],
      ),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.2),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // App Logo
        Image.asset(
          'assets/brand_logos/logo_text.png',
          height: 40,
          fit: BoxFit.contain,
        ),

        // User status badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: isPremiumUser
                ? const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 181, 156, 13), // gold
                      Color.fromARGB(255, 224, 111, 35), // orange
                    ],
                  )
                : LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
            border: Border.all(
              color: isPremiumUser
                  ? Colors.blue.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.2),
              width: 1.2,
            ),
          ),
          child: Text(
            isPremiumUser ? "Premium" : "Standard",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isPremiumUser ? Colors.white : Colors.white70,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    ),
  );
}
