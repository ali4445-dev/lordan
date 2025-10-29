import 'package:flutter/material.dart';

TextSpan formatApiText(String text) {
  final List<TextSpan> spans = [];
  final lines = text.split('\n');

  for (var line in lines) {
    if (line.trim().isEmpty) {
      spans.add(const TextSpan(text: '\n'));
      continue;
    }

    // Title style: ##Title##
    final titleMatch = RegExp(r'##(.*?)##').firstMatch(line);
    if (titleMatch != null) {
      spans.add(
        TextSpan(
          text: '${titleMatch.group(1)?.toUpperCase()}\n',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.amberAccent,
          ),
        ),
      );
      continue;
    }

    // Handle **bold** inline
    final boldRegex = RegExp(r'\*\*(.*?)\*\*');
    int start = 0;
    final matches = boldRegex.allMatches(line);

    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: line.substring(start, match.start),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
      ));
      start = match.end;
    }

    if (start < line.length) {
      spans.add(TextSpan(
        text: line.substring(start),
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ));
    }

    spans.add(const TextSpan(text: '\n'));
  }

  return TextSpan(children: spans);
}
