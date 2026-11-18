import 'package:flutter_test/flutter_test.dart';
import 'package:guessup_game/data/models/word.dart';

void main() {
  test('normalizedKey is computed from text and display text is preserved', () {
    final word = Word(id: 'w1', text: '  New York  ');
    expect(word.normalizedKey, 'new york');
    expect(word.text, '  New York  ');
  });

  test('normalizedKey collapses internal whitespace', () {
    final spaced = Word(id: 'w2', text: 'Hello    World');
    expect(spaced.normalizedKey, 'hello world');
  });

  test('normalizedKey is case-insensitive', () {
    final upper = Word(id: 'w3', text: 'SUPERMAN');
    expect(upper.normalizedKey, 'superman');
  });

  test('word equality is by stable id', () {
    expect(Word(id: 'a', text: 'X'), Word(id: 'a', text: 'Y'));
    expect(Word(id: 'a', text: 'X') != Word(id: 'b', text: 'X'), true);
  });
}
