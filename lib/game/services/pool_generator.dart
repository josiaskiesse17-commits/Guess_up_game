import 'dart:math';

import '../../data/models/word.dart';
import '../../data/repositories/category_repository.dart';

/// Generates a unified, shuffled, de-duplicated word pool from selected
/// categories.
///
/// Pure and side-effect-free (except [Random]), making it easy to test in
/// isolation. Multiple selected categories form one combined pool — there is
/// no alternation and no enforced equal distribution.
class PoolGenerator {
  final Random _random = Random();

  /// Build one combined pool from the selected categories.
  ///
  /// - Combines all words from every selected category into a single pool.
  ///   Removes duplicates using [Word.normalizedKey] (case-insensitive,
  ///   whitespace-normalized), preserving the first occurrence's display text.
  ///   Shuffles the result.
  List<Word> generatePool(
    List<String> categoryIds,
    CategoryRepository repository,
  ) {
    final words = <Word>[];
    for (final id in categoryIds) {
      final category = repository.findById(id);
      if (category != null) {
        words.addAll(category.words);
      }
    }
    return _dedupeAndShuffle(words);
  }

  List<Word> _dedupeAndShuffle(List<Word> words) {
    final seen = <String>{};
    final unique = <Word>[];
    for (final word in words) {
      final key = word.normalizedKey;
      if (key.isEmpty || seen.contains(key)) continue;
      seen.add(key);
      unique.add(word);
    }
    unique.shuffle(_random);
    return unique;
  }

  /// Reshuffle an existing pool, avoiding an immediate repeat of [lastKey].
  /// When all words share [lastKey] (a single unique word), repetition is
  /// accepted to avoid infinite reshuffling.
  List<Word> reshuffle(List<Word> pool, {String? lastKey}) {
    if (pool.isEmpty) return const <Word>[];
    final shuffled = List<Word>.from(pool)..shuffle(_random);

    if (lastKey != null &&
        shuffled.length > 1 &&
        shuffled.first.normalizedKey == lastKey) {
      var leadIndex = -1;
      for (var i = 1; i < shuffled.length; i++) {
        if (shuffled[i].normalizedKey != lastKey) {
          leadIndex = i;
          break;
        }
      }
      if (leadIndex != -1) {
        final lead = shuffled.removeAt(leadIndex);
        shuffled.insert(0, lead);
      }
    }
    return shuffled;
  }
}
