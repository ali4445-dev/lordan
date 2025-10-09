import 'package:flutter/material.dart';

@immutable
class Message {
  final String id;
  final String role; // 'user' or 'assistant'
  final String content;
  final DateTime createdAt;
  final bool isStreaming;

  const Message({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.isStreaming = false,
  });

  Message copyWith({
    String? id,
    String? role,
    String? content,
    DateTime? createdAt,
    bool? isStreaming,
  }) {
    return Message(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
}
