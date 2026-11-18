/// A single guessable word with a stable identifier.
class Word {
  /// Stable unique identifier for this word.
  final String id;

  /// Display text, preserved exactly as authored.
  final String text;

  Word({
    required this.id,
    required this.text,
  });

  /// Normalized comparison key used for deduplication.
  ///
  /// Derived from [text]: lowercased, internal whitespace collapsed to a
  /// single space, and trimmed. The original [text] is always preserved for
  /// display; this key is used only to detect duplicate entries across
  /// categories.
  String get normalizedKey {
    return text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  @override
  String toString() => 'Word(id: $id, text: $text)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Word && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
