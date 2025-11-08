import 'dart:ui';

import 'package:flutter/material.dart';
import '../paywall_screen.dart';

Widget buildFeatureList(List<String> features) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: features.map((feature) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFFFFD700), size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                feature,
                style: TextStyle(
                  color:
                      const Color.fromARGB(255, 216, 213, 209).withAlpha(220),
                  fontSize: 15,
                  height: 1.3, // line spacing
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );
}
