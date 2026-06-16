import 'package:flutter_tts/flutter_tts.dart';

abstract class NarrationPlayer {
  Future<void> speak(String text);

  Future<void> stop();
}

class FlutterTtsNarrationPlayer implements NarrationPlayer {
  FlutterTtsNarrationPlayer({FlutterTts? flutterTts})
    : _flutterTts = flutterTts ?? FlutterTts();

  final FlutterTts _flutterTts;
  bool _configured = false;

  Future<void> _configure() async {
    if (_configured) {
      return;
    }

    await _flutterTts.setLanguage('en-IN');
    await _flutterTts.setSpeechRate(0.44);
    await _flutterTts.setPitch(1.08);
    await _flutterTts.setVolume(1);
    await _flutterTts.awaitSpeakCompletion(true);
    _configured = true;
  }

  @override
  Future<void> speak(String text) async {
    await _configure();
    final result = await _flutterTts.speak(text);
    if (result == 0) {
      throw const NarrationException('The device could not start narration.');
    }
  }

  @override
  Future<void> stop() async {
    await _flutterTts.stop();
  }
}

class NarrationException implements Exception {
  const NarrationException(this.message);

  final String message;

  @override
  String toString() => message;
}
