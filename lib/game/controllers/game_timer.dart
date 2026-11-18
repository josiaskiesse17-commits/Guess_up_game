import 'dart:async';

/// A deadline-based round timer.
///
/// Remaining time is derived from a fixed deadline rather than from counting
/// periodic ticks, so it stays accurate even if tick events are delayed.
/// Only one timer instance is active at a time, and callbacks are dropped
/// after [stop] or [dispose].
class GameTimer {
  static const Duration _tickInterval = Duration(seconds: 1);

  Timer? _timer;
  DateTime? _deadline;
  bool _disposed = false;
  bool _running = false;

  /// Total round duration in seconds.
  final int durationSeconds;

  int _remainingSeconds;

  /// Stream of remaining-time updates (emits whole seconds) while running.
  final StreamController<int> _remainingController =
      StreamController<int>.broadcast();

  /// Fired once when the round finishes (deadline reached).
  final void Function()? onFinished;

  /// Current remaining seconds (authoritative, read-only).
  int get remainingSeconds => _remainingSeconds;

  /// Whether the timer is currently running.
  bool get isRunning => _running;

  /// Emits remaining time each second while the timer runs.
  Stream<int> get remainingStream => _remainingController.stream;

  GameTimer({
    required this.durationSeconds,
    int? remainingSeconds,
    this.onFinished,
  }) : _remainingSeconds = remainingSeconds ?? durationSeconds;

  /// Start (or restart) the timer from [remainingSeconds] (or the full
  /// duration if not provided).
  void start({int? remainingSeconds}) {
    if (_disposed) return;
    stop();
    _running = true;
    _remainingSeconds = remainingSeconds ?? durationSeconds;
    _deadline = DateTime.now().add(Duration(seconds: _remainingSeconds));
    _remainingController.add(_remainingSeconds);

    _timer = Timer.periodic(_tickInterval, (_) {
      if (_disposed || !_running) return;
      final now = DateTime.now();
      final diff = _deadline!.difference(now).inSeconds;
      final remaining = diff.clamp(0, durationSeconds);
      if (remaining != _remainingSeconds) {
        _remainingSeconds = remaining;
        _remainingController.add(remaining);
      }
      if (remaining <= 0) {
        _finish();
      }
    });
  }

  void _finish() {
    if (_disposed) return;
    _running = false;
    _timer?.cancel();
    _timer = null;
    _remainingSeconds = 0;
    _remainingController.add(0);
    onFinished?.call();
  }

  /// Stop the timer without firing [onFinished]. Preserves remaining time.
  void stop() {
    _running = false;
    _timer?.cancel();
    _timer = null;
  }

  /// Pause: stop ticking but preserve remaining time for resumption.
  void pause() => stop();

  /// Resume from the preserved remaining time.
  void resume() {
    if (_disposed) return;
    start(remainingSeconds: _remainingSeconds);
  }

  /// Dispose: stop the timer and close the stream. No further callbacks.
  void dispose() {
    stop();
    _disposed = true;
    _remainingController.close();
  }
}
