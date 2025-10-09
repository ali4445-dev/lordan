import 'package:flutter/material.dart';

import '../../../../theme.dart';

class RememberMeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const RememberMeCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            checkColor: Colors.white,
            side: BorderSide(color: Colors.white.withValues(alpha: 0.8)),
            value: value,
            onChanged: onChanged,
            activeColor: kDarkBlue,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Remember me',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
