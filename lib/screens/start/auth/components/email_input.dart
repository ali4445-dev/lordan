import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../theme.dart';

class EmailInput extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String?> onErrorChanged;
  final bool isDark;

  const EmailInput({
    super.key,
    required this.controller,
    required this.errorText,
    required this.onErrorChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            autovalidateMode: AutovalidateMode.disabled,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter your email',
              hintStyle: const TextStyle(color: Colors.white70),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: SvgPicture.asset(
                  'assets/icons/email.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  width: 22,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              errorStyle: const TextStyle(fontSize: 0, height: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.white),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                onErrorChanged('Please enter your email');
                return '';
              }
              final emailReg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailReg.hasMatch(value.trim())) {
                onErrorChanged('Please enter a valid email');
                return '';
              }
              onErrorChanged(null);
              return null;
            },
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
