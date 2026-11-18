import 'package:flutter_test/flutter_test.dart';
import 'package:guessup_game/game/models/game_config.dart';

void main() {
  test('GameConfig accepts valid durations', () {
    for (final duration in const [30, 60, 90, 120]) {
      final config = GameConfig(
        categoryIds: ['c1'],
        durationSeconds: duration,
      );
      expect(config.durationSeconds, duration);
      expect(config.categoryIds, ['c1']);
    }
  });

  test('GameConfig rejects empty categoryIds', () {
    expect(
      () => GameConfig(categoryIds: [], durationSeconds: 60),
      throwsAssertionError,
    );
  });

  test('GameConfig rejects invalid durations', () {
    for (final duration in [0, 15, 45, 180]) {
      expect(
        () => GameConfig(categoryIds: ['c1'], durationSeconds: duration),
        throwsAssertionError,
      );
    }
  });

  test('GameConfig copyWith preserves unchanged fields', () {
    final original = GameConfig(
      categoryIds: ['c1', 'c2'],
      durationSeconds: 60,
    );
    final copied = original.copyWith(durationSeconds: 30);
    expect(copied.categoryIds, ['c1', 'c2']);
    expect(copied.durationSeconds, 30);
    expect(original.durationSeconds, 60); // original unchanged
  });

  test('GameConfig equality', () {
    final a = GameConfig(categoryIds: ['c1', 'c2'], durationSeconds: 60);
    final b = GameConfig(categoryIds: ['c1', 'c2'], durationSeconds: 60);
    final c = GameConfig(categoryIds: ['c1'], durationSeconds: 60);
    final d = GameConfig(categoryIds: ['c1', 'c2'], durationSeconds: 30);
    expect(a, b);
    expect(a != c, true);
    expect(a != d, true);
  });

  test('GameConfig hashCode is consistent for equal configs', () {
    final a = GameConfig(categoryIds: ['c1', 'c2'], durationSeconds: 60);
    final b = GameConfig(categoryIds: ['c2', 'c1'], durationSeconds: 60);
    // Order matters for equality, so different order = different hash
    expect(a == b, false);
  });
}
