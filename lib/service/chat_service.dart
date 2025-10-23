import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lordan_v1/global.dart';

/// ✅ Sends a message to your Supabase Edge Function
/// Supports both 'text' and 'tts' modes.
Future<Map<String, dynamic>> sendToLordan(String message,
    {String role = 'study',
    String plan = 'free',
    String mode = 'text',
    String locale = 'en-US',
    String userKey = 'user123'}) async {
  await dotenv.load(fileName: ".env");

  const functionUrl =
      'https://aaemoamrwoyzgcelwmpu.supabase.co/functions/v1/rapid-function'; // ✅ your deployed Edge Function URL
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
  debugPrint("Request Reached");
  final response = await http.post(
    Uri.parse(functionUrl),
    headers: {
      'Authorization': 'Bearer $supabaseAnonKey',
      'Content-Type': 'application/json',
    },
    body: GlobalData.messageCount != 3
        ? jsonEncode({
            'message': message,
            'plan': plan,
            'mode': mode,
            'locale': locale,
            'role': role,
            "userKey": userKey
          })
        : jsonEncode({"userKey": userKey, "generateSummary": true}),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (GlobalData.messageCount! < 3) {
      GlobalData.messageCount = GlobalData.messageCount! + 1;
    } else {
      print("Reached Summary Stage");
      return {
        'summary': jsonBody['summary'] ?? '',
        'mode': jsonBody['mode'] ?? ''
        // will be null if mode=text
      };
    }

    // ✅ Always return structured map (easier to handle TTS + text)
    return {
      'reply': jsonBody['reply'] ?? '',
      'audio_b64': jsonBody['audio_b64'],
      // will be null if mode=text
    };
  } else {
    throw Exception('Failed with ${response.statusCode}: ${response.body}');
  }
}
