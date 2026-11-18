import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Plays the short local feedback sounds used for gameplay actions.
class GameAudio {
  final AudioPlayer _correctPlayer = AudioPlayer();
  final AudioPlayer _skipPlayer = AudioPlayer();

  Future<void> playCorrect() async {
    await _play(_correctPlayer, 'sounds/correct.wav');
  }

  Future<void> playSkip() async {
    await _play(_skipPlayer, 'sounds/skip.wav');
  }

  Future<void> _play(AudioPlayer player, String asset) async {
    try {
      await player.stop();
      await player.play(AssetSource(asset), mode: PlayerMode.lowLatency);
    } catch (error) {
      debugPrint('Unable to play feedback sound: $error');
    }
  }

  Future<void> dispose() async {
    await _correctPlayer.dispose();
    await _skipPlayer.dispose();
  }
}
