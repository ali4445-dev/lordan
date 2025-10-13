import 'package:hive/hive.dart';
import 'chat_mode.dart';

part 'user_chat_data.g.dart';

@HiveType(typeId: 2)
class UserChatData {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final Map<String, ChatMode> chatModes;

  UserChatData({
    required this.email,
    required this.chatModes,
  });
}
