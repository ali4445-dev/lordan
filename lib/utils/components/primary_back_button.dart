import 'package:flutter/material.dart';

class PrimaryBackButton extends StatelessWidget {
  const PrimaryBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10.0,
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white.withValues(alpha: 0.2),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
