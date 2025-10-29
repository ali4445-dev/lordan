import 'package:flutter/material.dart';

import '../../../theme.dart';

/// COMPONENT: Header Section
class HeaderSection extends StatelessWidget {
  const HeaderSection(
      {super.key,
      required this.title,
      this.subtitle = '',
      required this.logoVisible});

  final String title;
  final String subtitle;
  final bool logoVisible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive breakpoints
    final isTablet = screenWidth >= 720 && screenWidth < 1024;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// COMPONENT: App Logo
        if (logoVisible) ...[
          Image.asset(
            'assets/brand_logos/logo_png.png',
            width: isTablet ? 74 : 90,
            color: Colors.white.withValues(alpha: 0.8),
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8.0),
        ],

        /// Title
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 6),

        /// Subtitle
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 16,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : Colors.white.withValues(alpha: 0.7),
              height: 1.3,
            ),
          ),

        // if (logoVisible) ...[
        //   Image.asset(
        //     'assets/brand_logos/logo_png.png',
        //     width: isTablet ? 84 : 120,
        //     color: Colors.white.withValues(alpha: 0.8),
        //     fit: BoxFit.cover,
        //   ),
        //   const SizedBox(height: 12.0),
        // ],
        //
        // /// COMPONENT: Title
        // Text(
        //   title,
        //   textAlign: TextAlign.center,
        //   style: theme.textTheme.headlineMedium?.copyWith(
        //     fontWeight: FontWeight.w700,
        //     letterSpacing: -0.2,
        //     color: Colors.white.withValues(alpha: 0.9),
        //   ),
        // ),
        // const SizedBox(height: 8),
        //
        // /// COMPONENT: Subtitle
        // if (subtitle.isNotEmpty)
        //   Text(
        //     subtitle,
        //     textAlign: TextAlign.center,
        //     style: theme.textTheme.labelMedium?.copyWith(
        //       fontSize: 16,
        //       color: isDark ? AppColors.textSecondaryDark : Colors.white.withValues(alpha: 0.7),
        //       height: 1.4,
        //     ),
        //   ),
      ],
    );
  }
}
