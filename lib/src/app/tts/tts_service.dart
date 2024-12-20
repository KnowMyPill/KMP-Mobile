import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;

import 'package:pillkaboo/src/core/pillkaboo_util.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeakingRepeatedly = false;
  double _ttsSpeed = PKBAppState().ttsSpeed;

  TtsService() {
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    if (Platform.isIOS) {
      await _flutterTts.setSharedInstance(true);
    }
  }

  // set tts speed
  void setTtsSpeed(double speed) {
    _ttsSpeed = speed;
  }

  Future<void> speak(String text) async {
    await _flutterTts.setLanguage("ko-KR");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(_ttsSpeed);
    if (PKBAppState().silentMode == false) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isSpeakingRepeatedly = false; // Ensure to stop repeated speaking
  }

  Future<void> speakRepeatedly(String text) async {
    _isSpeakingRepeatedly = true;
    while (_isSpeakingRepeatedly && PKBAppState().silentMode == false) {
      await speak(text);
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  void stopRepeatedSpeaking() async {
    _isSpeakingRepeatedly = false;
    await stop();
  }
}
