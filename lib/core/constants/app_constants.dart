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
  /// Default pitch threshold (degrees) for registering a tilt.
  static const double defaultThreshold = 15.0;

  /// Default cooldown between registered actions (milliseconds).
  static const int defaultCooldownMilliseconds = 800;

  /// Fraction of the threshold below which the phone is considered "neutral"
  /// and able to register a new action.
  static const double neutralReturnFraction = 0.3;
}
