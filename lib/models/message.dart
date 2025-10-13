import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'message.g.dart'; // Required for Hive type adapter generation

@HiveType(typeId: 1)
class Message extends HiveObject {
  @HiveField(0)
  final String id;

  /// 'user' or 'assistant'
  @HiveField(1)
  final String role;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final bool isStreaming;

  /// Optional: Mode of chat (e.g. "default", "premium", "casual", etc.)
  /// Defaults to "default" if not provided — so older code still works.
  @HiveField(5)
  final String chatMode;

  /// Optional: The email or unique user id for session identification
  /// Defaults to "guest" if not provided.
  @HiveField(6)
  final String userId;

  Message({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.isStreaming = false,
    this.chatMode = 'default',
    this.userId = 'guest',
  });

  Message copyWith({
    String? id,
    String? role,
    String? content,
    DateTime? createdAt,
    bool? isStreaming,
    String? chatMode,
    String? userId,
  }) {
    return Message(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isStreaming: isStreaming ?? this.isStreaming,
      chatMode: chatMode ?? this.chatMode,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'sender': role,
        'createdAt': createdAt.toIso8601String(),
      };
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      role: json['sender'] ?? 'assistant', // since 'sender' key used in toJson
      content: json['content'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isStreaming: json['isStreaming'] ?? false,
      chatMode: json['chatMode'] ?? 'default',
      userId: json['userId'] ?? 'guest',
    );
  }

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
}
