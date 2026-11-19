class AppConstants {
  static const String appName = 'Guess Up';

  /// Supported round durations in seconds.
  static const List<int> roundDurations = [30, 60, 90, 120];

  /// Default round duration in seconds.
  static const int defaultDurationSeconds = 60;

  /// Application version displayed on the home screen.
  static const String appVersion = '0.1.0';

  /// Asset path for bundled category/word data.
  static const String categoriesAssetPath = 'assets/data/categories.json';
}

/// Route names (wired as screens are implemented in Milestone 2).
class AppRoutes {
  static const String home = '/';
  static const String categorySelection = '/categories';
  static const String roundSettings = '/settings';
  static const String gameplay = '/gameplay';
  static const String results = '/results';
}

/// Configuration for tilt detection.
///
/// Values are kept configurable so physical tilt directions and thresholds
/// can be verified on a target Android device without code changes.
class SensorConstants {
  /// Threshold (degrees) beyond which a forward/down tilt is correct.
  static const double correctThreshold = 35.0;

  /// Threshold (degrees) beyond which a backward/up tilt is a skip.
  static const double skipThreshold = 35.0;

  /// Default cooldown between registered actions (milliseconds).
  static const int cooldownMilliseconds = 800;

  /// Degrees within which the device must return to neutral before the next
  /// action can fire.
  static const double returnToNeutralDegrees = 15.0;

  /// Exponential smoothing alpha for the raw angle (0 = no smoothing,
  /// 1 = raw samples).
  static const double smoothingAlpha = 0.3;

  /// Number of smoothed samples averaged to establish the neutral position
  /// after reset().
  static const int calibrationSamples = 10;

  /// When true, flips the sign of the measured delta (for devices mounted
  /// the opposite way).
  static const bool invertTilt = false;

  /// When true, GameplayScreen shows a temporary tilt debug overlay.
  static const bool showTiltDebug = true;
}
