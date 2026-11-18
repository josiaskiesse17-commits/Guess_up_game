import 'package:flutter_test/flutter_test.dart';
import 'package:guessup_game/game/controllers/game_timer.dart';

void main() {
  test('timer counts down from configured duration', () {
    final timer = GameTimer(durationSeconds: 5, onFinished: () {});
    expect(timer.remainingSeconds, 5);
    expect(timer.isRunning, false);

    timer.start();
    expect(timer.isRunning, true);
    expect(timer.remainingSeconds, 5);
    timer.dispose();
  });

  test('stop preserves remaining time and does not fire onFinished', () {
    var finished = false;
    final t2 = GameTimer(durationSeconds: 5, onFinished: () => finished = true);
    t2.start();
    t2.stop();
    expect(finished, false);
    expect(t2.isRunning, false);
    t2.dispose();
  });

  test('resume continues from preserved remaining time', () {
    final t3 = GameTimer(durationSeconds: 3, onFinished: () {});
    t3.start();
    t3.stop();
    expect(t3.remainingSeconds, 3);
    t3.resume();
    expect(t3.isRunning, true);
    t3.dispose();
  });

  test('duplicate start cancels previous timer (no overlapping timers)', () {
    final t4 = GameTimer(durationSeconds: 3, onFinished: () {});
    t4.start();
    t4.start();
    expect(t4.isRunning, true);
    t4.dispose();
  });

  test('dispose prevents further callbacks', () {
    var finished = false;
    final t5 = GameTimer(durationSeconds: 1, onFinished: () => finished = true);
    t5.start();
    t5.dispose();
    expect(t5.isRunning, false);
    expect(finished, false);
  });
}
