// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_mode.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatModeAdapter extends TypeAdapter<ChatMode> {
  @override
  final int typeId = 0;

  @override
  ChatMode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMode(
      modeName: fields[0] as String,
      messages: (fields[1] as List).cast<Message>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatMode obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.modeName)
      ..writeByte(1)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
