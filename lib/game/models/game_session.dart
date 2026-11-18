import 'dart:math';

import '../../data/models/word.dart';
import '../models/session_status.dart';

/// Manages the mutable state of a single game session.
///
/// The session owns the word pool, current position, scoring and completion
/// status. It deliberately does NOT own the timer or the sensor — those are
/// coordinated by [GameController]. A session is single-use per round; for
/// replay a fresh [GameSession] is created with a fresh shuffled pool.
class GameSession {
  /// The word pool for this session (shuffled, de-duplicated).
  List<Word> pool;

  /// Current round duration in seconds.
  final int durationSeconds;

  int _index = 0;
  int _correct = 0;
  int _skipped = 0;
  SessionStatus _status = SessionStatus.idle;

  /// Normalized key of the last shown word, used to prevent immediate
  /// repetition across pool reshuffles.
  String? _lastShownNormalizedKey;

  /// Whether the session is currently active.
  bool get isPlaying => _status == SessionStatus.playing;

  /// Whether the session has completed.
  bool get isCompleted => _status == SessionStatus.completed;

  /// The currently displayed word, or null if none is active.
  Word? get currentWord {
    if (!isPlaying || _index >= pool.length) return null;
    return pool[_index];
  }

  /// Number of correct answers.
  int get correct => _correct;

  /// Number of skipped words.
  int get skipped => _skipped;

  /// Total number of answered words (correct + skipped).
  int get answeredCount => _correct + _skipped;

  /// Whether the pool is exhausted (no more words to show).
  bool get isExhausted => _index >= pool.length;

  /// Remaining words in the pool.
  int get remaining => (pool.length - _index).clamp(0, pool.length);

  GameSession({required this.pool, required this.durationSeconds})
    : assert(pool.isNotEmpty, 'Pool must not be empty');

  /// Start (or restart) the session with a fresh pool and duration.
  void start(List<Word> freshPool, int duration) {
    pool = freshPool;
    _status = SessionStatus.playing;
    _index = 0;
    _correct = 0;
    _skipped = 0;
    _lastShownNormalizedKey = null;
  }

  /// Register a correct answer for the current word and advance.
  void registerCorrect() {
    if (!isPlaying || isExhausted) return;
    _correct++;
    _advance();
  }

  /// Register a skip for the current word and advance.
  void registerSkip() {
    if (!isPlaying || isExhausted) return;
    _skipped++;
    _advance();
  }

  void _advance() {
    if (_index < pool.length) {
      _lastShownNormalizedKey = pool[_index].normalizedKey;
    }
    _index++;
    if (_index < pool.length) {
      return;
    }
    // Pool exhausted: attempt a safe reshuffle so the round can continue.
    _reshuffle();
  }

  void _reshuffle() {
    final rng = Random();
    final shuffled = List<Word>.from(pool)..shuffle(rng);

    // Prevent immediate repetition: ensure the first word of the new batch
    // differs (by normalized key) from the last shown word.
    if (_lastShownNormalizedKey != null &&
        shuffled.length > 1 &&
        shuffled.first.normalizedKey == _lastShownNormalizedKey) {
      var leadIndex = -1;
      for (var i = 1; i < shuffled.length; i++) {
        if (shuffled[i].normalizedKey != _lastShownNormalizedKey) {
          leadIndex = i;
          break;
        }
      }
      if (leadIndex != -1) {
        final lead = shuffled.removeAt(leadIndex);
        shuffled.insert(0, lead);
      }
      // If every word shares the same normalized key (a single unique word),
      // repetition is accepted to avoid infinite reshuffling.
    }

    // Replace pool contents with the new ordering and reset position.
    pool
      ..clear()
      ..addAll(shuffled);
    _index = 0;
    _status = SessionStatus.playing;
  }

  /// Complete the session (timer expired). No further input is accepted.
  void complete() {
    _status = SessionStatus.completed;
  }

  @override
  String toString() =>
      'GameSession(status: $_status, index: $_index, correct: $_correct, '
      'skipped: $_skipped, remaining: $remaining)';
}
