import 'dart:async';
import 'dart:ui' show PlatformDispatcher, Locale;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Small utilities used across the app:
/// - safeAsync wrapper
/// - logging helpers
/// - locale helpers
/// - simple TTS service (flutter_tts wrapper)
/// - TokenProvider: a hook to register a token-getter callback from supabase service

// Logging

void logInfo(String msg, [Object? data]) {
  if (kDebugMode) {
    // You can replace with a structured logger later
    debugPrint('[INFO] $msg${data != null ? ' -> $data' : ''}');
  }
}

void logError(String msg, [Object? error]) {
  // Consider sending to Sentry or other logger in production
  debugPrint('[ERROR] $msg${error != null ? ' -> $error' : ''}');
}

// safeAsync

/// Run an async function and catch/log errors.
/// Returns the result or `null` on error.
Future<T?> safeAsync<T>(
  Future<T> Function() action, {
  void Function(Object error, StackTrace stack)? onError,
}) async {
  try {
    return await action();
  } catch (e, st) {
    logError('safeAsync caught error', e);
    if (onError != null) onError(e, st);
    return null;
  }
}

// Locale helpers

/// Get device primary locale (best-effort).
Locale getDeviceLocale() {
  try {
    final locale = PlatformDispatcher.instance.locale;
    return locale;
  } catch (e) {
    // Fallback
    return const Locale('en');
  }
}

/// Resolve a locale from a list of supported language codes.
/// - supported: ['en','ge','ru']
/// - preferred: optional preferred Locale
// Locale resolveLocale(List<String> supported, [Locale? preferred]) {
//   // use preferred if supported
//   if (preferred != null) {
//     final lang = preferred.languageCode.toLowerCase();
//     if (supported.contains(lang)) return Locale(lang);
//   }
//
//   // try device locale
//   final device = getDeviceLocale();
//   if (supported.contains(device.languageCode.toLowerCase())) {
//     return Locale(device.languageCode.toLowerCase());
//   }
//
//   // fallback to first supported or 'en'
//   if (supported.isNotEmpty) return Locale(supported.first);
//   return const Locale('en');
// }

/// Return the fallback locale code (ISO 639-1), defaults to 'en'.
// String fallbackLocale() => 'en';

/// Resolve the user locale code (e.g., 'en', 'es', 'fr').
/// - If [preferred] provided and included in [supported], return it.
/// - Else try device locale against [supported].
/// - Else return [fallbackLocale()].
// String resolveUserLocale({
//   String? preferred,
//   List<String> supported = const ['en'],
// }) {
//   if (preferred != null && preferred.trim().isNotEmpty) {
//     final norm = preferred.split(RegExp(r'[-_]')).first.toLowerCase();
//     if (supported.contains(norm)) return norm;
//   }
//   try {
//     final device = PlatformDispatcher.instance.locale;
//     final code = device.languageCode.toLowerCase();
//     if (supported.contains(code)) return code;
//   } catch (_) {
//     // ignore
//   }
//   return fallbackLocale();
// }

// Token provider hook

/// TokenProvider allows the Supabase service to register a callback that
/// returns current access token (JWT). We avoid tight coupling with Supabase
/// in this utils file by exposing a callback setter that services set later.
///
/// Usage:
///   TokenProvider.setTokenGetter(() async => await supabaseService.getAccessToken());
class TokenProvider {
  static Future<String?> Function()? _getter;

  /// Set a custom token getter (usually from supabase_service).
  static void setTokenGetter(Future<String?> Function() getter) {
    _getter = getter;
  }

  /// Clear the getter (useful for tests).
  static void clear() {
    _getter = null;
  }

  /// Get access token if available.
  static Future<String?> getToken() async {
    if (_getter != null) {
      try {
        return await _getter!();
      } catch (e) {
        logError('TokenProvider.getToken error', e);
        return null;
      }
    }
    return null;
  }
}

// TTS wrapper

/// Simple TTS wrapper around flutter_tts.
/// - Keeps a ValueNotifier<bool> isSpeaking to allow UI to react.
/// - Exposes speak(text), stop(), dispose().
class TtsService {
  final FlutterTts _tts;
  final ValueNotifier<bool> isSpeaking = ValueNotifier<bool>(false);
  final StreamController<bool> _isSpeakingController = StreamController<bool>.broadcast();

  /// Stream of speaking state changes.
  Stream<bool> get isSpeakingStream => _isSpeakingController.stream;

  TtsService({FlutterTts? tts}) : _tts = tts ?? FlutterTts() {
    _tts.setStartHandler(() {
      isSpeaking.value = true;
      _isSpeakingController.add(true);
    });
    _tts.setCompletionHandler(() {
      isSpeaking.value = false;
      _isSpeakingController.add(false);
    });
    _tts.setCancelHandler(() {
      isSpeaking.value = false;
      _isSpeakingController.add(false);
    });
    // Optional: handle progress, errors
    _tts.setErrorHandler((msg) {
      logError('TTS error: $msg');
      isSpeaking.value = false;
      _isSpeakingController.add(false);
    });
  }

  /// Speak text. Optionally specify language code, e.g. 'en-US'.
  Future<void> speak(String text, {String? language}) async {
    if (text.trim().isEmpty) return;
    try {
      if (language != null) {
        await _tts.setLanguage(language);
      }
      await _tts.stop();
      final result = await _tts.speak(text);
      if (result == 1 || result == "1") {
        isSpeaking.value = true;
      }
    } catch (e) {
      logError('TtsService.speak failed', e);
      rethrow;
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
      isSpeaking.value = false;
    } catch (e) {
      logError('TtsService.stop failed', e);
    }
  }

  void dispose() {
    isSpeaking.dispose();
    _tts.stop();
    _isSpeakingController.close();
  }
}

// Token utilities (Supabase)

/// Read the current Supabase [Session], if any.
Session? readSession() {
  try {
    return Supabase.instance.client.auth.currentSession;
  } catch (e, st) {
    logError('readSession failed', e);
    if (kDebugMode) debugPrintStack(stackTrace: st);
    return null;
  }
}

/// Check if a token expiration [expiry] is in the past.
bool isTokenExpired(DateTime expiry) {
  return DateTime.now().isAfter(expiry);
}
