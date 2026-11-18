/// Immutable configuration for a game round.
///
/// Captures the player's category selection and round duration so that replay
/// can preserve the configuration while starting a fresh session.
class GameConfig {
  /// Selected category identifiers (at least one required).
  final List<String> categoryIds;

  /// Round duration in seconds (30, 60, 90, or 120).
  final int durationSeconds;

  GameConfig({required this.categoryIds, required this.durationSeconds})
    : assert(categoryIds.isNotEmpty, 'At least one category is required'),
      assert(
        _validDuration(durationSeconds),
        'Duration must be 30, 60, 90, or 120 seconds',
      );

  static bool _validDuration(int value) =>
      const {30, 60, 90, 120}.contains(value);

  /// Creates a copy with the given fields replaced.
  GameConfig copyWith({List<String>? categoryIds, int? durationSeconds}) {
    return GameConfig(
      categoryIds: categoryIds ?? this.categoryIds,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  @override
  String toString() =>
      'GameConfig(categories: $categoryIds, duration: ${durationSeconds}s)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GameConfig) return false;
    if (categoryIds.length != other.categoryIds.length) return false;
    for (var i = 0; i < categoryIds.length; i++) {
      if (categoryIds[i] != other.categoryIds[i]) return false;
    }
    return durationSeconds == other.durationSeconds;
  }

  @override
  int get hashCode {
    var hash = durationSeconds.hashCode;
    for (final id in categoryIds) {
      hash ^= id.hashCode;
    }
    return hash;
  }
}
