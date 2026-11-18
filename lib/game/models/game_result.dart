import '../models/game_config.dart';
import '../models/game_session.dart';

class GameResult {
  /// Number of correct answers.
  final int correct;

  /// Number of skipped words.
  final int skipped;

  /// Round duration in seconds.
  final int durationSeconds;

  /// Selected category identifiers (preserved for replay).
  final List<String> categoryIds;

  /// Total number of answered words (correct + skipped).
  int get answeredCount => correct + skipped;

  GameResult({
    required this.correct,
    required this.skipped,
    required this.durationSeconds,
    required this.categoryIds,
  })  : assert(correct >= 0, 'Correct count must not be negative'),
        assert(skipped >= 0, 'Skipped count must not be negative'),
        assert(_validDuration(durationSeconds),
            'Duration must be 30, 60, 90, or 120 seconds');

  static bool _validDuration(int value) =>
      const {30, 60, 90, 120}.contains(value);

  /// Creates a [GameResult] from a completed [GameSession] and its [GameConfig].
  factory GameResult.fromSession(GameSession session, GameConfig config) {
    return GameResult(
      correct: session.correct,
      skipped: session.skipped,
      durationSeconds: session.durationSeconds,
      categoryIds: List.unmodifiable(config.categoryIds),
    );
  }

  @override
  String toString() =>
      'GameResult(correct: $correct, skipped: $skipped, '
      'duration: ${durationSeconds}s, categories: $categoryIds)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GameResult) return false;
    return correct == other.correct &&
        skipped == other.skipped &&
        durationSeconds == other.durationSeconds &&
        categoryIds.length == other.categoryIds.length &&
        categoryIds
            .asMap()
            .entries
            .every((e) => e.value == other.categoryIds[e.key]);
  }

  @override
  int get hashCode {
    var hash = correct.hashCode ^ skipped.hashCode ^ durationSeconds.hashCode;
    for (final id in categoryIds) {
      hash ^= id.hashCode;
    }
    return hash;
  }
}
