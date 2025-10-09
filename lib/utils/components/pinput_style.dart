import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../theme.dart';

PinTheme defaultPinTheme(BuildContext context) => PinTheme(
      width: 52,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        border: Border.all(color: kInputBorderColor.withValues(alpha: 0.7)),
        borderRadius: BorderRadius.circular(12.0),
      ),
    );

PinTheme focusedPinTheme(BuildContext context) => PinTheme(
      width: 52,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        border: Border.all(color: Theme.of(context).primaryColor, width: 1), //kPrimaryLight
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
