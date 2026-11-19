import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../core/constants/app_constants.dart';
import 'tilt_math.dart';

/// Events emitted by the tilt sensor.
enum TiltAction { correct, skip }

/// Configuration for tilt detection.
///
/// Values are kept configurable so physical tilt directions and thresholds
/// can be verified on a target Android device without code changes.
///
/// Note: the real [TiltSensor] builds its internal [TiltDetector] from
/// [SensorConstants], so these fields are kept for backward compatibility
/// with tests and callers but the effective thresholds come from
/// [SensorConstants].
class TiltSensorConfig {
  /// Pitch threshold (degrees) beyond which a forward/down tilt is correct.
  final double correctThreshold;

  /// Pitch threshold (degrees) beyond which a backward/up tilt is a skip.
  final double skipThreshold;

  /// Minimum milliseconds between registered actions.
  final int cooldownMilliseconds;

  const TiltSensorConfig({
    this.correctThreshold = SensorConstants.correctThreshold,
    this.skipThreshold = SensorConstants.skipThreshold,
    this.cooldownMilliseconds = SensorConstants.cooldownMilliseconds,
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
/// - The screen-normal (Z) angle is computed from every accelerometer sample,
///   making detection orientation-independent (portrait, landscape-left and
///   landscape-right give the same angle for the same screen tilt).
/// - Calibrates neutral = average of the first [SensorConstants.calibrationSamples]
///   smoothed samples after [TiltDetector.reset()]. No action fires during
///   calibration.
/// - Requires return to neutral before another action is accepted.
/// - Applies thresholds and a cooldown to prevent accidental or multiple
///   registrations from a single tilt.
class TiltSensor {
  final TiltSensorConfig config;

  // TEMP tilt debug
  final ValueNotifier<TiltDebugInfo> _debugNotifier =
      ValueNotifier<TiltDebugInfo>(TiltDebugInfo());

  /// Live debug info, populated only by the real sensor path.
  ValueListenable<TiltDebugInfo> get debug => _debugNotifier;

  void Function(TiltAction)? _onCorrect;
  void Function(TiltAction)? _onSkip;

  StreamSubscription<AccelerometerEvent>? _subscription;
  bool _disposed = false;
  bool _isListening = false;

  late final TiltDetector _detector;

  /// Whether the sensor is currently subscribed and listening.
  bool get isListening => _isListening;

  TiltSensor({required this.config}) {
    _detector = TiltDetector(
      alpha: SensorConstants.smoothingAlpha,
      correctThreshold: config.correctThreshold,
      skipThreshold: config.skipThreshold,
      returnToNeutralDegrees: SensorConstants.returnToNeutralDegrees,
      cooldownMilliseconds: config.cooldownMilliseconds,
      calibrationSamples: SensorConstants.calibrationSamples,
      invertTilt: SensorConstants.invertTilt,
    );
  }

  /// Start listening. Calibrates neutral from the first smoothed samples.
  Future<void> start({
    void Function(TiltAction)? onCorrect,
    void Function(TiltAction)? onSkip,
  }) async {
    if (_disposed || _isListening) return;
    _onCorrect = onCorrect;
    _onSkip = onSkip;
    _isListening = true;
    _detector.reset();

    _subscription =
        accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval)
            .listen(
              _onAccelerometerEvent,
              onError: (_, _) {
                stop();
              },
            );
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    if (_disposed || !_isListening) return;

    final angle = tiltAngleDegrees(event.x, event.y, event.z);
    final action = _detector.update(angle);

    // TEMP tilt debug
    final neutral = _detector.neutralAngle ?? 0.0;
    var delta = _detector.smoothedAngle - neutral;
    if (SensorConstants.invertTilt) {
      delta = -delta;
    }
    _debugNotifier.value = TiltDebugInfo(
      rawX: event.x,
      rawY: event.y,
      rawZ: event.z,
      smoothedAngle: _detector.smoothedAngle,
      neutralAngle: _detector.neutralAngle,
      delta: delta,
      correctThreshold: config.correctThreshold,
      skipThreshold: config.skipThreshold,
      returnToNeutralDegrees: SensorConstants.returnToNeutralDegrees,
      lastAction: _detector.lastAction,
      waitingForNeutral: _detector.isWaitingForNeutral,
      calibrating: _detector.isCalibrating,
    );

    if (action == null) return;
    final tiltAction = _mapToTiltAction(action);
    _register(tiltAction);
  }

  TiltAction _mapToTiltAction(TiltDetectorAction a) =>
      a == TiltDetectorAction.correct ? TiltAction.correct : TiltAction.skip;

  void _register(TiltAction action) {
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
