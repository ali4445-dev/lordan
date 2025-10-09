import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class MyPhoneInput extends StatelessWidget {
  const MyPhoneInput({
    super.key,
    required this.controller,
    this.label,
  });

  final TextEditingController controller;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)...[
          Text(
            label!,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
        ],

        // InternationalPhoneNumberInput
        InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber number) {
            controller.text = number.phoneNumber ?? '';
          },
          textAlign: TextAlign.left,
          cursorColor: theme.primaryColor,
          textStyle: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
          selectorTextStyle: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
          initialValue: PhoneNumber(isoCode: 'US'),
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.DIALOG,
            showFlags: true,
            useEmoji: true,
            trailingSpace: true,
          ),
          autoValidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter valid phone number';
            }
            return null;
          },
          inputDecoration: InputDecoration(
            hintText: 'Enter phone number',
            hintStyle: theme.textTheme.bodyLarge?.copyWith(color: Colors.white54),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}
