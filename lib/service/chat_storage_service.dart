import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:lordan_v1/global.dart';
import 'package:lordan_v1/models/message.dart';
import 'package:lordan_v1/service/user_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// adjust your import path

class ChatStorageService {
  static Box _chatBox = Hive.box("chatBox");
  static Box get chatBox => _chatBox;

  /// ✅ Add a message for a specific user and chat mode
  static Future<void> addMessage({
    required String chatMode,
    required String message,
  }) async {
    final box = UserStorageService.getUserBox;
    final summary = {
      "role": chatMode,
      "time": DateTime.now().toIso8601String(),
      "content": message,
    };

    String? email = await Supabase.instance.client.auth.currentUser!.email;
    print(message);
    print(chatMode);
    final userData =
        Map<String, dynamic>.from(box.get(email, defaultValue: {}));

    // final messages = (userData[chatMode] as List<Map<String, dynamic>>?) ?? [];
    // final rawList = userData[chatMode];
    // final List<Map<String, dynamic>> messages = rawList is List
    //     ? rawList
    //         .whereType<Map>() // filter only maps
    //         .map((e) => Map<String, dynamic>.from(e))
    //         .toList()
    //     : [];

    // messages.add(message.toJson());
    // userData[chatMode] = messages;

    // await chatBox.put(email, userData);

    // print(chatBox.toMap());

    final updatedSummaries =
        List<Map<String, dynamic>>.from(userData['summaries'] ?? []);
    if (GlobalData.user!.status == "premium" &&
        updatedSummaries.length == 100) {
      updatedSummaries.removeAt(0);
    } else if ((GlobalData.user!.status == "standard" ||
            GlobalData.user!.status == "trial") &&
        updatedSummaries.length == 10) {
      updatedSummaries.removeAt(0);
    }
    print(updatedSummaries);
    updatedSummaries.add(summary);
    print("\n${updatedSummaries}");

    userData['summaries'] = updatedSummaries;

    await box.put(email, userData);
  }

  /// ✅ Get all messages for a specific user & chat mode
  static Future<List<Message>> getMessages() async {
    final String? email = Supabase.instance.client.auth.currentUser?.email;

    if (email == null || email.isEmpty) {
      print("⚠️ No logged-in email found — returning empty message list.");
      return [];
    }

    final userData =
        Map<String, dynamic>.from(chatBox.get(email, defaultValue: {}));

    final List<Message> allMessages = [];
    final now = DateTime.now();
    final updatedMessages = [];
    // 🔹 Loop through all chat modes (like reflect, studyPrep, etc.)
    userData.forEach((mode, messagesList) {
      if (messagesList is List) {
        final updatedModeMessages = <Map<String, dynamic>>[];
        for (var item in messagesList) {
          if (item is Map) {
            try {
              final message = Message.fromJson(Map<String, dynamic>.from(item));
              final msg =
                  Message.fromJson(Map<String, dynamic>.from(item)).copyWith(
                chatMode: mode, // set mode here
              );
              final age = now.difference(msg.createdAt).inHours;
              if (age < 24) {
                updatedModeMessages.add(message.toJson());
                allMessages.add(msg);
              }
            } catch (e) {
              print("⚠️ Error converting message for mode [$mode]: $e");
            }
          }
        }
        userData[mode] = updatedModeMessages;
      }
    });

    chatBox.put(email, userData);

    // Optional: sort messages by time (oldest → newest)
    allMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return allMessages;
  }

  /// ✅ Get all chat modes for a specific user
  static List<String> getChatModes(String email) {
    final userData =
        Map<String, dynamic>.from(chatBox.get(email, defaultValue: {}));
    return userData.keys.cast<String>().toList();
  }

  /// ✅ Get all stored users (emails)
  static List<String> getAllUsers() {
    return chatBox.keys.cast<String>().toList();
  }

  /// ✅ Delete all messages for a specific mode under a user
  static Future<void> clearChatMode({
    required String email,
    required String chatMode,
  }) async {
    final userData =
        Map<String, dynamic>.from(chatBox.get(email, defaultValue: {}));

    if (userData.containsKey(chatMode)) {
      userData.remove(chatMode);
      await chatBox.put(email, userData);
    }
  }

  /// ✅ Delete all messages for a specific user
  static Future<void> clearUserChats(String email) async {
    await chatBox.delete(email);
  }

  static Future<void> deleteMessage(Message message) async {
    final email = Supabase.instance.client.auth.currentUser!.email;
    if (email == null) return;

    final chatBox = Hive.box('chatBox');
    final userData =
        Map<String, dynamic>.from(chatBox.get(email, defaultValue: {}));

    // Find correct mode and remove
    if (userData.containsKey(message.chatMode)) {
      final msgList =
          List<Map<String, dynamic>>.from(userData[message.chatMode]);
      msgList.removeWhere((m) => m['id'] == message.id);
      userData[message.chatMode] = msgList;
      await chatBox.put(email, userData);
    }
  }
}
