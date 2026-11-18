import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/repositories/category_repository.dart';
import '../controllers/game_timer.dart';
import '../models/game_config.dart';
import '../models/game_session.dart';
import '../models/session_status.dart';
import '../services/pool_generator.dart';
import '../services/tilt_sensor.dart';

/// Immutable snapshot of session state exposed to the UI.
class GameSessionState {
  final SessionStatus status;
  final GameSession? session;
  final GameTimer? timer;
  final String? error;

  const GameSessionState.idle({this.error})
    : status = SessionStatus.idle,
      session = null,
      timer = null;

  const GameSessionState.playing(this.session, this.timer)
    : status = SessionStatus.playing,
      error = null;

  const GameSessionState.completed(this.session)
    : status = SessionStatus.completed,
      timer = null,
      error = null;

  const GameSessionState.error(this.error)
    : status = SessionStatus.idle,
      session = null,
      timer = null;
}

/// Coordinates the game session, timer, and sensor lifecycle.
///
/// Single source of truth for a round: owns [config], [session], [timer]
/// and [sensor]. Maps sensor/fallback input to session actions and exposes
/// state for the UI via [state]. The timer and sensor are independent of
/// gameplay logic; this controller is the only place they are wired together.
class GameController {
  final CategoryRepository _repository;
  final PoolGenerator _poolGenerator;
  final TiltSensor _sensor;
  final GameConfig _config;

  GameSession? _session;
  GameTimer? _timer;
  StreamSubscription<int>? _timerSubscription;

  /// Current session state exposed to the UI.
  final ValueNotifier<GameSessionState> state = ValueNotifier(
    const GameSessionState.idle(),
  );

  bool get isPlaying => _session != null && _session!.isPlaying;
  GameConfig get config => _config;
  GameSession? get session => _session;
  GameTimer? get timer => _timer;

  GameController({
    required this._repository,
    required this._poolGenerator,
    required this._sensor,
    required this._config,
  });

  /// Begin a round with the current configuration.
  Future<void> startGame() async {
    _timerSubscription?.cancel();
    _timerSubscription = null;
    final hadActiveRound = _timer != null;
    _timer?.dispose();
    _timer = null;
    if (hadActiveRound) {
      _sensor.stop();
    }

    final pool = _poolGenerator.generatePool(_config.categoryIds, _repository);
    if (pool.isEmpty) {
      state.value = const GameSessionState.error('No words available');
      return;
    }
    _session = GameSession(pool: pool, durationSeconds: _config.durationSeconds)
      ..start(pool, _config.durationSeconds);
    _timer = GameTimer(
      durationSeconds: _config.durationSeconds,
      onFinished: _onRoundComplete,
    );
    await _sensor.start(
      onCorrect: (_) => registerCorrect(),
      onSkip: (_) => registerSkip(),
    );
    _timer!.start();
    _timerSubscription = _timer!.remainingStream.listen((_) => _notify());
    state.value = GameSessionState.playing(_session!, _timer!);
  }

  /// Register a correct answer for the current word.
  void registerCorrect() {
    final session = _session;
    if (session == null || !session.isPlaying) return;
    session.registerCorrect();
    _notify();
  }

  /// Register a skip for the current word.
  void registerSkip() {
    final session = _session;
    if (session == null || !session.isPlaying) return;
    session.registerSkip();
    _notify();
  }

  void _onRoundComplete() {
    _session?.complete();
    _sensor.stop();
    state.value = GameSessionState.completed(_session!);
  }

  void _notify() {
    if (_session == null || _timer == null) return;
    state.value = GameSessionState.playing(_session!, _timer!);
  }

  /// Handle app backgrounding: pause the timer and stop sensor input.
  void onAppPaused() {
    _timer?.pause();
    _sensor.stop();
  }

  /// Handle app resumption: continue the timer and restart the sensor.
  void onAppResumed() {
    _timer?.resume();
    if (_session != null && _session!.isPlaying) {
      _sensor.start(
        onCorrect: (_) => registerCorrect(),
        onSkip: (_) => registerSkip(),
      );
    }
  }

  /// Replay: preserve [config], create a fresh session and fresh shuffled pool.
  Future<void> replay() async {
    stop();
    await startGame();
  }

  /// Stop the timer and sensor, and mark the session complete.
  void stop() {
    _timer?.stop();
    _sensor.stop();
    _session?.complete();
  }

  void dispose() {
    _timerSubscription?.cancel();
    _timer?.dispose();
    _sensor.dispose();
    state.dispose();
  }
}
