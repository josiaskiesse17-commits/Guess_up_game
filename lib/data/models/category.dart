import 'word.dart';

/// A built-in category containing a collection of words.
class Category {
  /// Stable unique identifier for this category.
  final String id;

  /// Display name shown to the player.
  final String name;

  /// Icon identifier used for category cards.
  final String icon;

  /// Words belonging to this category.
  final List<Word> words;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.words,
  });

  @override
  String toString() =>
      'Category(id: $id, name: $name, words: ${words.length})';
}
