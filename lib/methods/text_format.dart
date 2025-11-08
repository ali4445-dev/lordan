import 'package:flutter/material.dart';

TextSpan formatApiText(String text) {
  final List<TextSpan> spans = [];
  final lines = text.split('\n');

  for (var line in lines) {
    if (line.trim().isEmpty) {
      spans.add(const TextSpan(text: '\n'));
      continue;
    }

    // ✅ WhatsApp-like Title (##title##)
    final titleMatch = RegExp(r'##(.*?)##').firstMatch(line);
    if (titleMatch != null) {
      spans.add(
        TextSpan(
          text: '${titleMatch.group(1)?.trim()}\n',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: Color(0xFF25D366), // WhatsApp green accent
            height: 1.4,
          ),
        ),
      );
      continue;
    }

    // ✅ WhatsApp-like Heading (**heading**)
    final boldRegex = RegExp(r'\*\*(.*?)\*\*');
    int start = 0;
    final matches = boldRegex.allMatches(line);

    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: line.substring(start, match.start),
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFFECECEC), // light gray text
            height: 1.4,
          ),
        ));
      }

      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white, // bold heading look
          height: 1.4,
        ),
      ));

      start = match.end;
    }

    // ✅ WhatsApp-like Normal Text
    if (start < line.length) {
      spans.add(TextSpan(
        text: line.substring(start),
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Color(0xFFECECEC),
          height: 1.4,
        ),
      ));
    }
  }

  return TextSpan(children: spans);
}
