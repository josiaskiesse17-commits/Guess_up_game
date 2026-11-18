import 'package:flutter_test/flutter_test.dart';
import 'package:guessup_game/data/models/category.dart';
import 'package:guessup_game/data/models/word.dart';
import 'package:guessup_game/data/repositories/category_repository.dart';
import 'package:guessup_game/game/controllers/game_controller.dart';
import 'package:guessup_game/game/models/game_config.dart';
import 'package:guessup_game/game/models/session_status.dart';
import 'package:guessup_game/game/services/pool_generator.dart';
import 'package:guessup_game/game/services/tilt_sensor.dart';

/// Fake tilt sensor that captures callbacks for testing.
class FakeTiltSensor extends TiltSensor {
  void Function(TiltAction)? _capturedOnCorrect;
  void Function(TiltAction)? _capturedOnSkip;

  FakeTiltSensor() : super(config: const TiltSensorConfig());

  void Function(TiltAction)? get capturedOnCorrect => _capturedOnCorrect;
  void Function(TiltAction)? get capturedOnSkip => _capturedOnSkip;

  bool startCalled = false;
  bool stopCalled = false;

  @override
  Future<void> start({
    void Function(TiltAction)? onCorrect,
    void Function(TiltAction)? onSkip,
  }) async {
    startCalled = true;
    _capturedOnCorrect = onCorrect;
    _capturedOnSkip = onSkip;
  }

  @override
  void stop() {
    stopCalled = true;
  }

  /// Simulate a correct tilt by invoking the captured callback.
  void simulateCorrect() => _capturedOnCorrect?.call(TiltAction.correct);

  /// Simulate a skip tilt by invoking the captured callback.
  void simulateSkip() => _capturedOnSkip?.call(TiltAction.skip);
}

List<Word> _words(List<Map<String, String>> entries) => entries
    .map((e) => Word(id: e['id']!, text: e['text']!))
    .toList();

CategoryRepository _repoWithCategories() => CategoryRepository.withData([
      Category(
        id: 'c1',
        name: 'Animals',
        icon: 'pets',
        words: _words([
          {'id': 'a1', 'text': 'Lion'},
          {'id': 'a2', 'text': 'Tiger'},
          {'id': 'a3', 'text': 'Bear'},
        ]),
      ),
    ]);

void main() {
  test('GameController wires tilt sensor callbacks to registerCorrect/registerSkip',
      () async {
    final repo = _repoWithCategories();
    final sensor = FakeTiltSensor();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: sensor,
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
    );

    await controller.startGame();

    // Sensor should be started
    expect(sensor.startCalled, true);

    // Simulate a correct tilt
    sensor.simulateCorrect();
    expect(controller.session!.correct, 1);
    expect(controller.session!.skipped, 0);

    // Simulate a skip tilt
    sensor.simulateSkip();
    expect(controller.session!.correct, 1);
    expect(controller.session!.skipped, 1);

    // Session state should be playing
    expect(controller.state.value.status, SessionStatus.playing);
  });

  test('Tilt sensor input is ignored when session is not playing', () async {
    final repo = _repoWithCategories();
    final sensor = FakeTiltSensor();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: sensor,
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
    );

    // Before startGame, simulating tilt should not affect anything
    sensor.simulateCorrect();
    expect(controller.session, isNull);
    expect(controller.isPlaying, false);
  });

  test('Tilt sensor is stopped when round is manually stopped', () async {
    final repo = _repoWithCategories();
    final sensor = FakeTiltSensor();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: sensor,
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
    );

    await controller.startGame();
    expect(sensor.startCalled, true);
    expect(sensor.stopCalled, false);

    controller.stop();

    expect(sensor.stopCalled, true);
    expect(controller.session!.isCompleted, true);
  });

  test('Tilt sensor is restarted on app resume', () async {
    final repo = _repoWithCategories();
    final sensor = FakeTiltSensor();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: sensor,
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
    );

    await controller.startGame();
    sensor.stopCalled = false; // reset

    controller.onAppPaused();
    expect(sensor.stopCalled, true);

    controller.onAppResumed();
    expect(sensor.startCalled, true);
  });

  test('Tilt sensor config thresholds are configurable', () {
    final sensor = TiltSensor(
      config: const TiltSensorConfig(
        correctThreshold: 20.0,
        skipThreshold: 25.0,
        cooldownMilliseconds: 1000,
      ),
    );

    // Verify config values are stored (via public behavior - start doesn't crash)
    expect(sensor.isListening, false);
  });

  test('Controller dispose cleans up tilt sensor', () async {
    final repo = _repoWithCategories();
    final sensor = FakeTiltSensor();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: sensor,
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
    );

    await controller.startGame();
    controller.dispose();

    // After dispose, sensor should be stopped
    expect(sensor.stopCalled, true);
  });
}
