import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lordan_v1/service/chat_storage_service.dart';
import 'message.dart';

class HistoryItem extends StatefulWidget {
  final String email;
  final String chatMode;

  const HistoryItem({
    super.key,
    required this.email,
    required this.chatMode,
  });

  @override
  State<HistoryItem> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<HistoryItem> {
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final msgs = await ChatStorageService.getMessages();

    setState(() {
      _messages = msgs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat - ${widget.chatMode}'),
      ),
      body: _messages.isEmpty
          ? const Center(child: Text("No messages yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg.role == 'user';

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.content,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
