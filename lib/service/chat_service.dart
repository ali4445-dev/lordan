import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lordan_v1/global.dart';

/// ✅ Sends a message to your Supabase Edge Function
/// Supports both 'text' and 'tts' modes.
Future<Map<String, dynamic>> sendToLordan(
  String message, {
  String plan = 'free',
  String mode = 'text',
  String locale = 'en-US',
}) async {
  await dotenv.load(fileName: ".env");

  const functionUrl =
      'https://aaemoamrwoyzgcelwmpu.supabase.co/functions/v1/rapid-function'; // ✅ your deployed Edge Function URL
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  final response = await http.post(
    Uri.parse(functionUrl),
    headers: {
      'Authorization': 'Bearer $supabaseAnonKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'message': message,
      'plan': GlobalData.plan,
      'mode': GlobalData.mode,
      'locale': GlobalData.language,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);

    // ✅ Always return structured map (easier to handle TTS + text)
    return {
      'reply': jsonBody['reply'] ?? '',
      'audio_b64': jsonBody['audio_b64'], // will be null if mode=text
    };
  } else {
    throw Exception('Failed with ${response.statusCode}: ${response.body}');
  }
}
