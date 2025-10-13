import 'package:hive/hive.dart';
import 'message.dart';

part 'chat_mode.g.dart';

@HiveType(typeId: 0)
class ChatMode {
  @HiveField(0)
  final String modeName;

  @HiveField(1)
  final List<Message> messages;

  ChatMode({
    required this.modeName,
    required this.messages,
  });
}
