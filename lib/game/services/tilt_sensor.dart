import 'dart:async';
import 'dart:math' as math;

import 'package:sensors_plus/sensors_plus.dart';

/// Events emitted by the tilt sensor.
enum TiltAction { correct, skip }

/// Configuration for tilt detection.
///
/// Values are kept configurable so physical tilt directions and thresholds
/// can be verified on a target Android device without code changes.
class TiltSensorConfig {
  /// Pitch threshold (degrees) beyond which a forward/down tilt is correct.
  final double correctThreshold;

  /// Pitch threshold (degrees) beyond which a backward/up tilt is a skip.
  final double skipThreshold;

  /// Minimum milliseconds between registered actions.
  final int cooldownMilliseconds;

  const TiltSensorConfig({
    this.correctThreshold = 15.0,
    this.skipThreshold = 15.0,
    this.cooldownMilliseconds = 800,
  });

  TiltSensorConfig copyWith({
    double? correctThreshold,
    double? skipThreshold,
    int? cooldownMilliseconds,
  }) {
    return TiltSensorConfig(
      correctThreshold: correctThreshold ?? this.correctThreshold,
      skipThreshold: skipThreshold ?? this.skipThreshold,
      cooldownMilliseconds: cooldownMilliseconds ?? this.cooldownMilliseconds,
    );
  }
}

/// Reads accelerometer data and translates deliberate tilts into game actions.
///
/// Independent of gameplay logic: it knows nothing about words, score, or
/// timer. The gameplay layer maps [TiltAction] events to Correct/Skip.
///
/// Behavior:
/// - Calibrates the neutral position from the first reading (the player
///   should hold the phone in the intended starting position). Does not
///   continuously recalibrate while the phone is moving.
/// - Requires a return to neutral before another action is accepted.
/// - Applies thresholds and a cooldown to prevent accidental or multiple
///   registrations from a single tilt.
class TiltSensor {
  final TiltSensorConfig config;

  void Function(TiltAction)? _onCorrect;
  void Function(TiltAction)? _onSkip;

  StreamSubscription<AccelerometerEvent>? _subscription;
  bool _disposed = false;
  bool _isListening = false;

  double? _neutralPitch;
  bool _calibrated = false;

  DateTime? _lastActionTime;
  bool _awaitingNeutral = false;

  /// Whether the sensor is currently subscribed and listening.
  bool get isListening => _isListening;

  TiltSensor({required this.config});

  /// Start listening. Calibrates the neutral position from the first reading.
  Future<void> start({
    void Function(TiltAction)? onCorrect,
    void Function(TiltAction)? onSkip,
  }) async {
    if (_disposed || _isListening) return;
    _onCorrect = onCorrect;
    _onSkip = onSkip;
    _isListening = true;
    _calibrated = false;
    _neutralPitch = null;
    _lastActionTime = null;
    _awaitingNeutral = false;

    _subscription = accelerometerEventStream().listen(
      _onAccelerometerEvent,
      onError: (_, _) {
        stop();
      },
    );
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    if (_disposed || !_isListening) return;

    // Calibrate neutral from the first reading (still starting position).
    if (!_calibrated) {
      _neutralPitch = _pitch(event);
      _calibrated = true;
      return;
    }

    // Cooldown protection.
    if (_lastActionTime != null) {
      final elapsed = DateTime.now()
          .difference(_lastActionTime!)
          .inMilliseconds;
      if (elapsed < config.cooldownMilliseconds) return;
    }

    final pitch = _pitch(event);
    final delta = pitch - _neutralPitch!;

    // Require return to neutral before accepting another action.
    if (_awaitingNeutral) {
      if (delta.abs() <= config.correctThreshold * 0.3) {
        _awaitingNeutral = false;
      }
      return;
    }

    // Detect deliberate tilts.
    if (delta >= config.correctThreshold) {
      _register(TiltAction.correct);
    } else if (delta <= -config.skipThreshold) {
      _register(TiltAction.skip);
    }
  }

  double _pitch(AccelerometerEvent event) {
    // Pitch from accelerometer: atan2(-y, sqrt(x*x + z*z)) in degrees.
    return (math.atan2(
          -event.y,
          math.sqrt(event.x * event.x + event.z * event.z),
        ) *
        180 /
        math.pi);
  }

  void _register(TiltAction action) {
    _lastActionTime = DateTime.now();
    _awaitingNeutral = true;
    if (action == TiltAction.correct) {
      _onCorrect?.call(action);
    } else {
      _onSkip?.call(action);
    }
  }

  /// Stop listening and cancel the subscription.
  void stop() {
    _isListening = false;
    _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    _disposed = true;
    stop();
  }
}
