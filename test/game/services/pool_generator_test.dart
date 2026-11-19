import 'package:flutter_test/flutter_test.dart';
import 'package:guessup_game/data/models/category.dart';
import 'package:guessup_game/data/models/word.dart';
import 'package:guessup_game/data/repositories/category_repository.dart';
import 'package:guessup_game/game/services/pool_generator.dart';

List<Word> _words(List<Map<String, String>> entries) =>
    entries.map((e) => Word(id: e['id']!, text: e['text']!)).toList();

void main() {
  test('single category produces its own word pool', () {
    final repo = CategoryRepository.withData([
      Category(
        id: 'c1',
        name: 'Animals',
        icon: 'pets',
        words: _words([
          {'id': 'a1', 'text': 'Lion'},
          {'id': 'a2', 'text': 'Tiger'},
        ]),
      ),
    ]);
    final pool = PoolGenerator().generatePool(['c1'], repo);
    expect(pool.length, 2);
    expect(pool.any((w) => w.text == 'Lion'), true);
    expect(pool.any((w) => w.text == 'Tiger'), true);
  });

  test('mixed categories form one unified pool with duplicates removed', () {
    final repo = CategoryRepository.withData([
      Category(
        id: 'c1',
        name: 'Animals',
        icon: 'pets',
        words: _words([
          {'id': 'a1', 'text': 'Lion'},
          {'id': 'a2', 'text': 'Tiger'},
        ]),
      ),
      Category(
        id: 'c2',
        name: 'Sports',
        icon: 'sports',
        words: _words([
          {'id': 's1', 'text': 'Tiger'},
          {'id': 's2', 'text': 'Soccer'},
        ]),
      ),
    ]);
    final pool = PoolGenerator().generatePool(['c1', 'c2'], repo);
    expect(pool.length, 3);
    expect(pool.any((w) => w.text == 'Lion'), true);
    expect(pool.any((w) => w.text == 'Tiger'), true);
    expect(pool.any((w) => w.text == 'Soccer'), true);
    // First occurrence's display text is preserved for the duplicate.
    expect(pool.firstWhere((w) => w.text == 'Tiger').id, 'a2');
  });

  test('dedup is case-insensitive and whitespace-normalized', () {
    final repo = CategoryRepository.withData([
      Category(
        id: 'c3',
        name: 'WS',
        icon: 'x',
        words: _words([
          {'id': 'w1', 'text': 'New York'},
          {'id': 'w2', 'text': '  new  york  '},
        ]),
      ),
    ]);
    final pool = PoolGenerator().generatePool(['c3'], repo);
    expect(pool.length, 1);
  });

  test('reshuffle avoids immediate repetition when possible', () {
    final repo = CategoryRepository.withData([
      Category(
        id: 'c1',
        name: 'Animals',
        icon: 'pets',
        words: _words([
          {'id': 'a1', 'text': 'Lion'},
          {'id': 'a2', 'text': 'Tiger'},
          {'id': 'a3', 'text': 'Bear'},
        ]),
      ),
    ]);
    final generator = PoolGenerator();
    final pool = generator.generatePool(['c1'], repo);
    final reshuffled = generator.reshuffle(
      pool,
      lastKey: pool.first.normalizedKey,
    );
    expect(reshuffled.length, pool.length);
    expect(reshuffled.first.normalizedKey, isNot(pool.first.normalizedKey));
  });

  test('single unique word pool reshuffles without infinite loop', () {
    final repo = CategoryRepository.withData([
      Category(
        id: 'c4',
        name: 'One',
        icon: 'x',
        words: _words([
          {'id': 'o1', 'text': 'Solo'},
        ]),
      ),
    ]);
    final generator = PoolGenerator();
    final pool = generator.generatePool(['c4'], repo);
    final again = generator.reshuffle(pool, lastKey: pool.first.normalizedKey);
    expect(again.length, 1);
  });
}
