import 'package:flutter/services.dart';

/// Plays platform-native feedback sounds for gameplay actions.
class GameAudio {
  Future<void> playCorrect() async {
    await SystemSound.play(SystemSoundType.click);
    await HapticFeedback.lightImpact();
  }

  Future<void> playSkip() async {
    await SystemSound.play(SystemSoundType.alert);
    await HapticFeedback.mediumImpact();
  }

  Future<void> dispose() async {}
}
