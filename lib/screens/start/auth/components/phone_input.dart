import 'package:flutter/material.dart';

import '../../../../theme.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;

  const PhoneInput({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassDark : AppColors.glassLight,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: isDark ? 0.06 : 0.18),
          width: 1.0,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Enter your phone number',
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
