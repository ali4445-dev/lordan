import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lordan_v1/global.dart';
import 'package:lordan_v1/service/audio_service.dart';
import 'package:lordan_v1/service/chat_service.dart';
import 'package:lordan_v1/service/chat_storage_service.dart';
import 'package:lordan_v1/utils/components/snack_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';

enum VoiceState { idle, listening, processing, speaking }

class VoiceChatProvider with ChangeNotifier {
  // Core dependencies
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  Timer? _silenceTimer;

  // State
  VoiceState _state = VoiceState.idle;
  bool _isContinuousMode = false;
  String _transcript = '';
  final List<Message> _messages = [];

  // Speech recognition state
  bool _isInitialized = false;
  StreamSubscription<SpeechRecognitionResult>? _recognitionSubscription;

  // Error handling
  String? _errorMessage;

  // Getters
  VoiceState get state => _state;

  bool get isContinuousMode => _isContinuousMode;

  String get transcript => _transcript;

  List<Message> get messages => List.unmodifiable(_messages);

  bool get isRecording => _state == VoiceState.listening;

  bool get isSpeaking => _state == VoiceState.speaking;

  bool get hasError => _errorMessage != null;

  String? get errorMessage => _errorMessage;
  DateTime? _startTime;
  int flowCount = 1;
  VoiceChatProvider() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);

    _tts.setCompletionHandler(() async {
      print("VoiceState is $_state");
      if (_isContinuousMode &&
          _state == VoiceState.speaking &&
          flowCount <= 6) {
        flowCount++;
        debugPrint("🔁 Restarting mic for conversation $flowCount");

        // Wait a tiny bit before restarting recognition
        await Future.delayed(const Duration(milliseconds: 800));
        _state = VoiceState.idle;
        print("Listening Again...");
        startListening();
      } else {
        _state = VoiceState.idle;
        clearError();
      }
      notifyListeners();
    });
  }

  Future<bool> _requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  // Future<bool> _initializeSpeech() async {
  //   if (_isInitialized) return true;
  //
  //   _isInitialized = await _speech.initialize(
  //     onError: (error) => _handleError('Speech recognition error: $error'),
  //     onStatus: (status) {
  //       if (status == 'done' && _state == VoiceState.listening) {
  //         _processTranscript();
  //       }
  //     },
  //   );
  //
  //   return _isInitialized;
  // }

  Future<bool> _initializeSpeech() async {
    if (_isInitialized) return true;

    _isInitialized = await _speech.initialize(
      onError: (error) {
        if (error.errorMsg == 'error_no_match') {
          debugPrint('No speech match, please try again.');
          return;
        }
        _handleError('Speech recognition error: ${error.errorMsg}');
      },
      onStatus: (status) {
        if (status == 'done' && _state == VoiceState.listening) {
          _processTranscript();
        }
      },
    );

    return _isInitialized;
  }

  Future<void> startListening({bool isPremium = false}) async {
    if (_state == VoiceState.listening) return;

    // Clear any previous errors
    clearError();

    // Check and request permission
    if (!await _requestPermission()) {
      _handleError('Microphone permission denied');
      return;
    }

    // Initialize speech recognition
    if (!await _initializeSpeech()) {
      _handleError('Failed to initialize speech recognition');
      return;
    }

    ///
    _startTime = DateTime.now();

    ///
    // Start listening
    _state = VoiceState.listening;
    _transcript = '';
    notifyListeners();

    try {
      await _speech.listen(
        onResult: (result) {
          notifyListeners();
          _transcript = result.recognizedWords;
          _resetSilenceTimer();
        },
        cancelOnError: true,
        partialResults: true,
        listenMode:
            _isContinuousMode ? ListenMode.dictation : ListenMode.confirmation,
      );
      _startSilenceTimer();
    } catch (e) {
      _handleError('Error starting speech recognition: $e');
    }
  }

  void _startSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(const Duration(seconds: 9), () {
      debugPrint("🕓 No speech detected for 5 seconds — stopping listening...");
      stopListening();
    });
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _startSilenceTimer();
  }

  Future<void> stopListening(
      {String mode = 'tts',
      bool isPremium = false,
      String language = 'en-US',
      String role = "study"}) async {
    if (_state != VoiceState.listening) return;
    await _tts.setLanguage(language);
    _silenceTimer?.cancel();
    if (_startTime!.second > 0) {
      // Step 3: Get end time
      DateTime endTime = DateTime.now();
      print("End time: $endTime");

      // Step 4: Calculate used time (in seconds)
      Duration usedTime = endTime.difference(_startTime!);
      int secondsUsed = usedTime.inSeconds;

      print("Time used: $secondsUsed seconds");
    }

    await _speech.stop();

    clearError();
    _processTranscript(
        mode: mode, isPremium: isPremium, language: language, role: role);
  }

  void _processTranscript(
      {String mode = 'tts',
      bool isPremium = false,
      String language = 'en-US',
      String role = "study"}) async {
    if (_transcript.isEmpty) {
      _state = VoiceState.idle;
      clearError();
      notifyListeners();
      return;
    }

    // Add user message
    _messages.add(Message(
      id: DateTime.now().toString(),
      role: 'user',
      content: _transcript,
      createdAt: DateTime.now(),
    ));

    // Process "AI" response (placeholder)
    _state = VoiceState.processing;
    notifyListeners();

    print(_transcript);

    await dynamicVoice();
    final userKey = GlobalData.user!.userKey;

    // TODO: Replace this with actual API call
    final aiResponse = await sendToLordan(_transcript,
        mode: mode,
        plan: isPremium ? "premium" : "free",
        locale: language,
        role: role,
        userKey: userKey);

    _messages.add(Message(
      id: DateTime.now().toString(),
      role: 'assistant',
      content: aiResponse['reply'] ?? "Please Wait",
      createdAt: DateTime.now(),
    ));

    print(aiResponse["reply"]);
    print(aiResponse["audio_b64"]);
    // if (aiResponse["audio_b64"] != null) {
    // playBase64Audio(aiResponse["audio_b64"]);
    // } else {
    await speak(aiResponse['reply']);
    try {
      if (GlobalData.messageCount == 12) {
        final Map<String, dynamic> jsonData =
            await sendToLordan('', userKey: userKey);
        ChatStorageService.addMessage(
            chatMode: GlobalData.mode ?? " ",
            message: aiResponse['reply'] ?? "");
        print("Summary Add to database");
        GlobalData.messageCount = 0;
      }
    } catch (e) {
      print("Error is $e");
    }

    // }

    // Speak the response

    // await speak(aiResponse['reply']);
    // ChatStorageService.addMessage(
    //     chatMode: GlobalData.mode!,
    //     message: Message(
    //         chatMode: GlobalData.mode!,
    //         id: const Uuid().v4(),
    //         role: 'assistant',
    //         content: aiResponse["reply"],
    //         createdAt: DateTime.now()));
    _transcript = '';
  }

  Future<void> speak(String text) async {
    _state = VoiceState.speaking;
    notifyListeners();

    try {
      await _tts.speak(text);
    } catch (e) {
      _handleError('Text-to-speech error: $e');
      _state = VoiceState.idle;
      notifyListeners();
    }
  }

  void toggleContinuousMode(bool value) {
    _isContinuousMode = value;
    if (_state == VoiceState.listening) {
      stopListening();
      startListening(); // Restart with new mode
    }
    notifyListeners();
  }

  void _handleError(String error) {
    debugPrint(error); // Log error for debugging
    _errorMessage = error;
    _state = VoiceState.idle;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _recognitionSubscription?.cancel();
    _speech.cancel();
    _tts.stop();
    _silenceTimer?.cancel();
    super.dispose();
  }

  Future<void> dynamicVoice() async {
    final voices = await _tts.getVoices;

    if (voices == null || voices.isEmpty) {
      print("⚠️ No voices found!");
      return;
    }

    // Check for male or female command
    if (transcript.contains("switch to male") ||
        transcript.contains("switch to mail")) {
      final maleVoice = voices.firstWhere(
        (voice) =>
            voice['gender']?.toString().toLowerCase() != 'female' ||
            !voice['name'].toString().toLowerCase().contains('female'),
        orElse: () => voices.first,
      );

      print("✅ Switching to male voice: $maleVoice");

      await _tts.setVoice({
        'name': maleVoice['name'],
        'locale': maleVoice['locale'],
      });
    } else if (transcript.contains("switch to female") ||
        transcript.contains("switch to female voice")) {
      final femaleVoice = voices.firstWhere(
        (voice) =>
            voice['name'].toString().toLowerCase().contains('female') ||
            voice['gender']?.toString().toLowerCase() == 'female',
        orElse: () => voices.first,
      );

      print("✅ Switching to female voice: $femaleVoice");

      await _tts.setVoice({
        'name': femaleVoice['name'],
        'locale': femaleVoice['locale'],
      });
    } else {
      print("ℹ️ No gender switch command detected.");
    }
  }
}
