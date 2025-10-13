// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_chat_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserChatDataAdapter extends TypeAdapter<UserChatData> {
  @override
  final int typeId = 2;

  @override
  UserChatData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserChatData(
      email: fields[0] as String,
      chatModes: (fields[1] as Map).cast<String, ChatMode>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserChatData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.chatModes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserChatDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
