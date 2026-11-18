import 'package:flutter_test/flutter_test.dart';
import 'package:guessup_game/data/models/category.dart';
import 'package:guessup_game/data/models/word.dart';
import 'package:guessup_game/data/repositories/category_repository.dart';
import 'package:guessup_game/game/controllers/game_controller.dart';
import 'package:guessup_game/game/models/game_config.dart';
import 'package:guessup_game/game/models/session_status.dart';
import 'package:guessup_game/game/services/pool_generator.dart';
import 'package:guessup_game/game/services/tilt_sensor.dart';

/// Fake tilt sensor for testing — does not subscribe to real sensors.
class FakeTiltSensor extends TiltSensor {
  FakeTiltSensor() : super(config: const TiltSensorConfig());

  @override
  Future<void> start({
    void Function(TiltAction)? onCorrect,
    void Function(TiltAction)? onSkip,
  }) async {
    // No-op in tests; avoid real sensor access.
  }

  @override
  void stop() {}

  @override
  void dispose() {}
}

List<Word> _words(List<Map<String, String>> entries) =>
    entries.map((e) => Word(id: e['id']!, text: e['text']!)).toList();

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
  Category(
    id: 'c2',
    name: 'Sports',
    icon: 'sports',
    words: _words([
      {'id': 's1', 'text': 'Soccer'},
      {'id': 's2', 'text': 'Tennis'},
    ]),
  ),
]);

void main() {
  test('GameController initializes with correct config and idle state', () {
    final repo = _repoWithCategories();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: FakeTiltSensor(),
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
    );

    expect(controller.config.categoryIds, ['c1']);
    expect(controller.config.durationSeconds, 60);
    expect(controller.isPlaying, false);
    expect(controller.session, isNull);
    expect(controller.timer, isNull);
    expect(controller.state.value.status, SessionStatus.idle);
  });

  test('startGame creates a session and timer, sets playing state', () async {
    final repo = _repoWithCategories();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: FakeTiltSensor(),
      config: GameConfig(categoryIds: ['c1', 'c2'], durationSeconds: 60),
    );

    await controller.startGame();

    expect(controller.isPlaying, true);
    expect(controller.session, isNotNull);
    expect(controller.timer, isNotNull);
    expect(controller.state.value.status, SessionStatus.playing);
    expect(controller.session!.pool.length, 5); // 3 + 2 = 5 unique words
    expect(controller.session!.currentWord, isNotNull);
  });

  test('startGame with empty pool produces error state', () async {
    final repo = CategoryRepository.withData([]);
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: FakeTiltSensor(),
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
    );

    await controller.startGame();

    expect(controller.state.value.status, SessionStatus.idle);
    expect(controller.state.value.error, 'No words available');
  });

  test('registerCorrect advances and scores through controller', () async {
    final repo = _repoWithCategories();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: FakeTiltSensor(),
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
    );

    await controller.startGame();

    controller.registerCorrect();
    expect(controller.session!.correct, 1);
    expect(controller.session!.skipped, 0);
    expect(controller.session!.answeredCount, 1);
  });

  test('registerSkip advances without scoring through controller', () async {
    final repo = _repoWithCategories();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: FakeTiltSensor(),
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
    );

    await controller.startGame();

    controller.registerSkip();
    expect(controller.session!.correct, 0);
    expect(controller.session!.skipped, 1);
    expect(controller.session!.answeredCount, 1);
  });

  test('register actions invoke their optional feedback callbacks', () async {
    final repo = _repoWithCategories();
    var correctCalls = 0;
    var skipCalls = 0;
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: FakeTiltSensor(),
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
      onCorrect: () => correctCalls++,
      onSkip: () => skipCalls++,
    );

    await controller.startGame();
    controller.registerCorrect();
    controller.registerSkip();

    expect(correctCalls, 1);
    expect(skipCalls, 1);
  });

  test('replay creates a fresh session with same config', () async {
    final repo = _repoWithCategories();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: FakeTiltSensor(),
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 30),
    );

    await controller.startGame();
    controller.registerCorrect();
    expect(controller.session!.correct, 1);

    await controller.replay();

    expect(controller.session!.correct, 0); // reset
    expect(controller.session!.skipped, 0);
    expect(controller.config.durationSeconds, 30); // preserved
    expect(controller.config.categoryIds, ['c1']); // preserved
    expect(controller.isPlaying, true);
  });

  test('stop completes the session and stops input', () async {
    final repo = _repoWithCategories();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: FakeTiltSensor(),
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
    );

    await controller.startGame();
    controller.stop();

    expect(controller.session!.isCompleted, true);
    controller.registerCorrect();
    expect(controller.session!.correct, 0); // no input after complete
  });

  test('onAppPaused pauses timer and stops sensor', () async {
    final repo = _repoWithCategories();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: FakeTiltSensor(),
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
    );

    await controller.startGame();
    controller.onAppPaused();

    expect(controller.timer!.isRunning, false);
  });

  test('onAppResumed resumes timer and restarts sensor', () async {
    final repo = _repoWithCategories();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: FakeTiltSensor(),
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
    );

    await controller.startGame();
    controller.onAppPaused();
    controller.onAppResumed();

    expect(controller.timer!.isRunning, true);
  });

  test('dispose cleans up resources', () async {
    final repo = _repoWithCategories();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: FakeTiltSensor(),
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
    );

    await controller.startGame();
    controller.dispose();

    expect(controller.timer!.isRunning, false);
  });

  test('dispose is safe to call more than once', () async {
    final repo = _repoWithCategories();
    final controller = GameController(
      repository: repo,
      poolGenerator: PoolGenerator(),
      sensor: FakeTiltSensor(),
      config: GameConfig(categoryIds: ['c1'], durationSeconds: 60),
    );

    await controller.startGame();
    controller.dispose();
    controller.dispose();

    expect(controller.timer!.isRunning, false);
  });
}
