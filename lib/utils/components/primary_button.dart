import 'package:flutter/material.dart';

import '../../theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onPressed,
    this.horizontalMargin = 12,
  });

  final String label;
  final bool enabled;
  final VoidCallback? onPressed;
  final double horizontalMargin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: enabled ? 1.0 : 0.55,
      child: GestureDetector(
        onTap: enabled ? onPressed : null,
        behavior: HitTestBehavior.opaque,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.22),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
            constraints: const BoxConstraints(minHeight: 52),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColors.secondaryLight, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.22), width: 1),
            ),
            child: Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ) ??
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
