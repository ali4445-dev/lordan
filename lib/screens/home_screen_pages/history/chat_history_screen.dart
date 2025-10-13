import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lordan_v1/providers/user_provider.dart';
import 'package:lordan_v1/service/chat_storage_service.dart';
import 'package:lordan_v1/theme.dart';
import 'package:lordan_v1/utils/components/glass_card.dart';
import 'package:lordan_v1/utils/components/gradient_backdrop.dart';
import 'package:lordan_v1/utils/components/primary_back_button.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lordan_v1/models/message.dart';

class ChatHistoryScreen extends StatefulWidget {
  static const String routeName = '/chat-history';

  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  late String email;
  late List<Message> _chatHistory = [];

  @override
  void initState() {
    super.initState();

    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      // Convert stored JSON data back into Message objects
      final allMessages = await ChatStorageService.getMessages();
      // userData.forEach((mode, list) {
      //   if (list is List) {
      //     history[mode] = list.map((e) => Message.fromJson(Map<String, dynamic>.from(e))).toList();
      //   }
      // });

      setState(() {
        _chatHistory = allMessages;
        print(_chatHistory.toList());
      });
    } catch (e) {
      print('Error loading chat history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    bool isDark = userProvider.themeMode == ThemeMode.dark;

    if (_chatHistory.isEmpty) {
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            GradientBackdrop(isDark: isDark),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "No chat history found.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GradientBackdrop(isDark: isDark),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return _buildModeSection(_chatHistory);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.glassLight.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: const Center(
        child: Row(
          children: [
            SizedBox(width: 10),
            Text(
              "Chat History",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSection(List<Message> messages) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.glassLight.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: EdgeInsets.only(top: 10),
        iconColor: Colors.white,
        title: const Center(
          child: Text(
            "Chat History",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: messages.map((msg) => _buildMessageBubble(msg)).toList(),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final formattedTime = DateFormat('hh:mm a').format(message.createdAt);
    final isUser = message.role == 'user';

    return Dismissible(
      key: Key(message.id), // unique key for each message
      direction: DismissDirection.endToStart, // swipe left to delete
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.redAccent,
          size: 28,
        ),
      ),
      onDismissed: (direction) async {
        // ✅ Remove from storage
        await ChatStorageService.deleteMessage(message);

        // ✅ Optionally show feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Message deleted'),
            duration: const Duration(seconds: 2),
          ),
        );

        // ✅ Optionally update UI if using a provider/state
        setState(() {
          _chatHistory.removeWhere((m) => m.id == message.id);
        });
      },
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isUser
                ? Colors.blueAccent.withOpacity(0.2)
                : Colors.greenAccent.withOpacity(0.2),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft:
                  isUser ? const Radius.circular(18) : const Radius.circular(0),
              bottomRight:
                  isUser ? const Radius.circular(0) : const Radius.circular(18),
            ),
            border: Border.all(
              color: isUser ? Colors.blueAccent : Colors.greenAccent,
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.4,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 4),
              Container(
                width: 150,
                child: Row(
                  children: [
                    Text(
                      formattedTime,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      message.chatMode,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
