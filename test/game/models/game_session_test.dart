import 'package:flutter_test/flutter_test.dart';
import 'package:guessup_game/data/models/word.dart';
import 'package:guessup_game/game/models/game_session.dart';

List<Word> _pool(int n) => List.generate(
      n,
      (i) => Word(id: 'w$i', text: 'Word $i'),
    );

void main() {
  test('Correct and Skip advance and score correctly', () {
    final session = GameSession(pool: _pool(5), durationSeconds: 60)
      ..start(_pool(5), 60);

    expect(session.isPlaying, true);
    expect(session.currentWord?.text, 'Word 0');

    session.registerCorrect();
    expect(session.correct, 1);
    expect(session.skipped, 0);
    expect(session.currentWord?.text, 'Word 1');

    session.registerSkip();
    expect(session.correct, 1);
    expect(session.skipped, 1);
    expect(session.currentWord?.text, 'Word 2');
  });

  test('each word is counted at most once', () {
    final session = GameSession(pool: _pool(5), durationSeconds: 60)
      ..start(_pool(5), 60);

    session.registerCorrect(); // index 1
    session.registerSkip(); // index 2
    session.registerCorrect(); // index 3 -> reshuffle (index 5 reached)
    session.registerCorrect(); // index 4 -> reshuffle
    session.registerCorrect(); // index 5 -> reshuffle

    expect(session.correct, 4);
    expect(session.skipped, 1);
    expect(session.isExhausted, false); // reshuffles instead of terminally exhausting
    expect(session.currentWord, isNotNull);
  });

  test('a completed session does not accept further input', () {
    final session = GameSession(pool: _pool(3), durationSeconds: 60)
      ..start(_pool(3), 60);

    session.complete();
    expect(session.isCompleted, true);

    final c = session.correct;
    final s = session.skipped;
    session.registerCorrect();
    session.registerSkip();
    expect(session.correct, c);
    expect(session.skipped, s);
  });

  test('new session does not inherit previous scores', () {
    final fresh = GameSession(pool: _pool(2), durationSeconds: 60)
      ..start(_pool(2), 60);
    expect(fresh.correct, 0);
    expect(fresh.skipped, 0);
    expect(fresh.isPlaying, true);
  });
}
