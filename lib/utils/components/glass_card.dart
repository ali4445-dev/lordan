import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child, required this.radiusTop, required this.radiusBottom});

  final Widget child;
  final Radius? radiusTop;
  final Radius? radiusBottom;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: radiusTop ?? const Radius.circular(20), bottom: radiusBottom ?? const Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.25),
          ),
        ),
        child: child,
      ),
    );
  }
}
