import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lordan_v1/global.dart';
import 'package:lordan_v1/service/audio_service.dart';
import 'package:lordan_v1/service/chat_service.dart';
import 'package:lordan_v1/service/chat_storage_service.dart';
import 'package:lordan_v1/utils/components/snack_bar.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';

class ChatProvider with ChangeNotifier {
  final _uuid = const Uuid();
  final List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;
  bool _hasContext = false;
  StreamSubscription? _messageStream;

  List<Message> get messages => List.unmodifiable(_messages);

  bool get isLoading => _isLoading;

  String? get error => _error;

  bool get hasContext => _hasContext;

  // Simulated streaming response - replace with actual API call
  Future<void> sendMessage(String content,
      {String mode = 'text',
      bool isPremium = false,
      String language = 'en',
      String role = "study"}) async {
    if (content.trim().isEmpty) return;

    try {
      _error = null;

      // Add user message
      _messages.add(Message(
        id: _uuid.v4(),
        role: 'user',
        content: content,
        createdAt: DateTime.now(),
      ));
      notifyListeners();

      _isLoading = true;
      notifyListeners();

      // ✅ Prepare to receive assistant response
      final responseId = _uuid.v4();
      final user_id = GlobalData.user.user_key;

      final Map<String, dynamic> jsonData = await sendToLordan(content,
          locale: language,
          plan: !isPremium ? 'free' : 'premium',
          role: role,
          userKey: user_id);
      if (GlobalData.messageCount == 12) {
        final Map<String, dynamic> jsonData =
            await sendToLordan('', userKey: user_id);
        ChatStorageService.addMessage(
          chatMode: role,
          message: jsonData["summary"].trim(),
        );
        print("Summary Add to database");
        GlobalData.messageCount = 0;
      }
      if (mode == 'tts') {
        // Get the Base64 audio string
        final audioB64 = jsonData['audio_b64'];

// Play it
        if (audioB64 != null && audioB64.isNotEmpty) {
          // await playBase64Audio(audioB64);
          print("Has to play the api incomingsound ${audioB64}");
        } else {
          print("No audio returned from AI.");
        }
      } else {
        // Extract just the 'reply' parameter
        final String botReply = jsonData['reply'] ?? 'No reply found';
        String responseText = '';

        // 🟢 Step 2: Stream the bot reply word by word (keep original UI animation)
        for (final word in botReply.split(' ')) {
          await Future.delayed(const Duration(milliseconds: 100));
          responseText += '$word ';

          _messages.removeWhere((m) => m.id == responseId);
          _messages.add(Message(
            id: responseId,
            role: 'assistant',
            content: responseText.trim(),
            createdAt: DateTime.now(),
            isStreaming: true,
          ));
          notifyListeners();
        }

        // 🟢 Step 3: Add final message (no streaming flag)
        _messages.removeWhere((m) => m.id == responseId);
        _messages.add(Message(
          id: responseId,
          role: 'assistant',
          content: responseText.trim(),
          createdAt: DateTime.now(),
        ));
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void deleteMessage(String messageId) {
    _messages.removeWhere((m) => m.id == messageId);
    notifyListeners();
  }

  void clearConversation() {
    _messages.clear();
    notifyListeners();
  }

  // Call this when navigating away
  @override
  void dispose() {
    _messageStream?.cancel();
    super.dispose();
  }

  // Check context availability from API
  Future<void> checkContext() async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      _hasContext = true;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
