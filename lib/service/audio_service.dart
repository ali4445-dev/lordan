import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

Future<void> playBase64Audio(String base64Audio) async {
  try {
    print("🎯 Reached playBase64Audio");

    final audioBytes = base64Decode(base64Audio);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/ai_response.mp3');
    await file.writeAsBytes(audioBytes);

    final fileExists = await file.exists();
    final fileSize = await file.length();
    print("📂 File path: ${file.path}");
    print("✅ Exists: $fileExists | 📏 Size: $fileSize bytes");

    if (!fileExists || fileSize < 2000) {
      print("❌ Audio file seems invalid or too small");
      return;
    }

    final player = AudioPlayer();
    await player.setReleaseMode(ReleaseMode.stop);
    await player.setVolume(1.0);

    final result = await player.play(DeviceFileSource(file.path));
    print("🎵 Play Ended");
  } catch (e) {
    print("❌ Error playing audio: $e");
  }
}
