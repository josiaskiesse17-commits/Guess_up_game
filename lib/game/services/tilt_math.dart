import 'dart:math' as math;

/// Pure computation: angle of the screen normal above/below the horizontal
/// plane. About 0 when the device is vertical, positive when the screen
/// faces up (ceiling), negative when it faces down (floor).
///
/// Uses the Z axis (screen normal), so the result is identical regardless of
/// how the device is rotated around Z (portrait vs landscape-left vs
/// landscape-right).
double tiltAngleDegrees(double x, double y, double z) {
  final magnitude = math.sqrt(x * x + y * y + z * z);
  if (magnitude < 0.01) return 0.0;
  final ratio = (z / magnitude).clamp(-1.0, 1.0);
  return math.asin(ratio) * 180 / math.pi;
}

/// Debug snapshot exposed by the real [TiltSensor].
class TiltDebugInfo {
  final double rawX;
  final double rawY;
  final double rawZ;
  final double smoothedAngle;
  final double? neutralAngle;
  final double delta;
  final double correctThreshold;
  final double skipThreshold;
  final double returnToNeutralDegrees;
  final TiltDetectorAction? lastAction;
  final bool waitingForNeutral;
  final bool calibrating;

  const TiltDebugInfo({
    this.rawX = 0.0,
    this.rawY = 0.0,
    this.rawZ = 0.0,
    this.smoothedAngle = 0.0,
    this.neutralAngle,
    this.delta = 0.0,
    this.correctThreshold = 0.0,
    this.skipThreshold = 0.0,
    this.returnToNeutralDegrees = 0.0,
    this.lastAction,
    this.waitingForNeutral = false,
    this.calibrating = true,
  });
}

/// Action detected by [TiltDetector].
enum TiltDetectorAction { correct, skip }

/// Stateful tilt detector: pure logic, no Flutter or sensor imports.
///
/// Feeds angle samples and returns [TiltDetectorAction]? (correct / skip /
/// null). Implements low-pass smoothing, neutral calibration, return-to-neutral
/// gating, and cooldown with an injectable clock for deterministic tests.
class TiltDetector {
  final double alpha;
  final double correctThreshold;
  final double skipThreshold;
  final double returnToNeutralDegrees;
  final int cooldownMilliseconds;
  final int calibrationSamples;
  final bool invertTilt;
  final int Function() nowMs;

  double _smoothed = 0.0;
  bool _smoothingInitialized = false;
  final List<double> _calibrationSamples = [];
  double? _neutral;
  bool _awaitingNeutral = false;
  int? _lastActionTimeMs;
  TiltDetectorAction? _lastAction;

  static int _defaultNowMs() => DateTime.now().millisecondsSinceEpoch;

  TiltDetector({
    required this.alpha,
    required this.correctThreshold,
    required this.skipThreshold,
    required this.returnToNeutralDegrees,
    required this.cooldownMilliseconds,
    required this.calibrationSamples,
    this.invertTilt = false,
    int Function()? nowMs,
  }) : nowMs = nowMs ?? _defaultNowMs;

  /// Reset calibration and smoothing state. Call when starting a new round.
  void reset() {
    _smoothed = 0.0;
    _smoothingInitialized = false;
    _calibrationSamples.clear();
    _neutral = null;
    _awaitingNeutral = false;
    _lastActionTimeMs = null;
    _lastAction = null;
  }

  /// Whether the detector is still collecting calibration samples.
  bool get isCalibrating =>
      _neutral == null && _calibrationSamples.length < calibrationSamples;

  /// Whether an action is blocked waiting for return to neutral.
  bool get isWaitingForNeutral => _awaitingNeutral;

  /// Last detected action (null if none).
  TiltDetectorAction? get lastAction => _lastAction;

  /// Current smoothed angle.
  double get smoothedAngle => _smoothed;

  /// Current neutral angle, or null if still calibrating.
  double? get neutralAngle => _neutral;

  /// Process one raw angle sample. Returns a detected action or null.
  TiltDetectorAction? update(double angle) {
    // Exponential low-pass smoothing.
    if (!_smoothingInitialized) {
      _smoothed = angle;
      _smoothingInitialized = true;
    } else {
      _smoothed = alpha * angle + (1.0 - alpha) * _smoothed;
    }

    // Collect calibration samples (only until neutral is established).
    if (_neutral == null) {
      _calibrationSamples.add(_smoothed);
      if (_calibrationSamples.length < calibrationSamples) {
        return null; // no action during calibration
      }
      _neutral =
          _calibrationSamples.reduce((a, b) => a + b) / calibrationSamples;
      _calibrationSamples.clear();
    }

    // Cooldown.
    final now = nowMs();
    if (_lastActionTimeMs != null &&
        now - _lastActionTimeMs! < cooldownMilliseconds) {
      return null;
    }

    var delta = _smoothed - _neutral!;
    if (invertTilt) {
      delta = -delta;
    }

    // Return-to-neutral gate.
    if (_awaitingNeutral) {
      if (delta.abs() <= returnToNeutralDegrees) {
        _awaitingNeutral = false;
      }
      return null;
    }

    // Tilt down: screen faces floor -> delta negative -> Correct.
    if (delta <= -correctThreshold) {
      _lastActionTimeMs = now;
      _awaitingNeutral = true;
      _lastAction = TiltDetectorAction.correct;
      return TiltDetectorAction.correct;
    }

    // Tilt up: screen faces ceiling -> delta positive -> Skip.
    if (delta >= skipThreshold) {
      _lastActionTimeMs = now;
      _awaitingNeutral = true;
      _lastAction = TiltDetectorAction.skip;
      return TiltDetectorAction.skip;
    }

    return null;
  }
}
